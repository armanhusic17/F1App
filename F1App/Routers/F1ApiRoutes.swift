//
//  F1Data_Model.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import Foundation

struct F1ApiRoutes  {
    typealias FoundationData = Foundation.Data
    
    static func retrieveCachedData(for seasonYear: String, queryKey: String) -> FoundationData? {
        let key = "cache_\(queryKey)_\(seasonYear)"
        if let cachedData = UserDefaults.standard.data(forKey: key) {
            return cachedData
        } else {
            // Log an error or handle the absence of data gracefully
            print("No cached data available for key: \(key)")
            return nil
        }
    }

    static func fetchConstructorImageFromWikipedia(constructorName: String) async throws -> String {
        let encodedName = constructorName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlStr = "https://en.wikipedia.org/w/api.php?action=query&titles=\(encodedName)&prop=pageimages&format=json&pithumbsize=800"
        guard let url = URL(string: urlStr) else {
            print(URLError(.badURL))
            return "bad_url"
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
        
        guard let pageID = wikipediaData.query.pages.keys.first,
              let page = wikipediaData.query.pages[pageID],
              let thumbnailURL = page.thumbnail?.source else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response for \(constructorName)"])
        }
        print(thumbnailURL)
        return thumbnailURL
    }
    
    static func getConstructorStandings(seasonYear: String) async throws -> [ConstructorStanding] {
        // Check the cache first
        if let cachedData = retrieveCachedData(for: seasonYear, queryKey: "constructorStandings") {
            do {
                let root = try JSONDecoder().decode(Root.self, from: cachedData)
                print("Successfully gathered data from cache")
                return processConstructorStandings(root: root)
            } catch {
                print("Error decoding cached data: \(error)")
                // Continue to fetch fresh data if cache is corrupted
            }
        }

        // Proceed with network call
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/constructorStandings.json?limit=100"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        if seasonYear != "\(Calendar.current.component(.year, from: Date()))" {
            UserDefaults.standard.set(data, forKey: "cache_constructorStandings_\(seasonYear)")
        }

        return processConstructorStandings(root: root)
    }

    private static func processConstructorStandings(root: Root) -> [ConstructorStanding] {
        guard let standingsList = root.mrData?.standingsTable?.standingsLists?.first else {
            print("Standings table not found")
            return []
        }
        
        return standingsList.constructorStandings ?? []
    }

    static func allRaceResults(seasonYear: String, round: String, completion: @escaping (Bool) -> Void) {
        print(seasonYear, round)
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/\(round)/results.json"
        guard let url = URL(string: urlString) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10 // set timeout to 10 seconds
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                print("Error: No data received")
                completion(false)
                return
            }
            do {
                let raceResults = try JSONDecoder().decode(RaceResults.self, from: data)
                guard let unwrappedRaces = raceResults.mrData?.raceTable?.races else {return}
                for race in unwrappedRaces {
                    F1DataStore.singleRaceName = "\(seasonYear)\n\(race.raceName ?? "") \nRound \(round)"
                    for result in race.results! {
                        F1DataStore.constructorID.append(result.constructor?.name)
                        F1DataStore.driverNames.append("\(result.driver?.givenName ?? "") \(result.driver?.familyName ?? "")")
                        F1DataStore.driverLastName.append(result.driver?.familyName)
                        F1DataStore.racePosition.append(result.position ?? "")
                        F1DataStore.racePoints.append(result.points)
                        F1DataStore.fastestLap.append("Fastest Lap: \(result.fastestLap?.time?.time ?? "")")
                        F1DataStore.raceTime.append("Starting Grid Position: \(result.grid ?? "")\nLaps Completed: \(result.laps ?? "")\nRace Pace: \(result.time?.time ?? "Way Off")")
                        F1DataStore.qualiResults.append(result.grid)
                     
                    }
                }
                completion(true)

            } catch let error {
                completion(false)
                print("Error decoding race results: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    static func getDriverResults(driverId: String, limit: Int, completion: @escaping (Bool, [Race]) -> Void) {
        let urlString = "https://ergast.com/api/f1/drivers/\(driverId)/results.json?limit=\(limit)"
        guard let url = URL(string: urlString) else {
            completion(false, [])
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10 // set timeout to 10 seconds
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error: No data received")
                completion(false, [])
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let mrData = json["MRData"] as? [String: Any],
                   let raceTable = mrData["RaceTable"] as? [String: Any],
                   let racesArray = raceTable["Races"] as? [[String: Any]] {
                    
                    var races = [Race]()
                    
                    for (index, raceData) in racesArray.enumerated() {
                        if let race = createRace(from: raceData) {
                            print("Processing race \(index + 1) of \(racesArray.count)")
                            races.append(race)
                        } else {
                            print("Error processing race \(index + 1)")
                            // Print the raceData or other relevant information to identify the issue
                        }
                    }
                    completion(true, races)
                    
                } else {
                    completion(false, [])
                    print("Error: Invalid JSON format driver results")
                }
            } catch let error {
                completion(false, [])
                print("Error decoding driver results: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    private static func createRace(from data: [String: Any]) -> Race? {
        guard let raceName = data["raceName"] as? String,
              let circuitData = data["Circuit"] as? [String: Any],
              let circuitName = circuitData["circuitName"] as? String,
              let locationData = circuitData["Location"] as? [String: Any],
              let locality = locationData["locality"] as? String,
              let country = locationData["country"] as? String,
              let date = data["date"] as? String,
              let resultsArray = data["Results"] as? [[String: Any]] else {
            return nil
        }
        
        var results = [Result]()
        for resultData in resultsArray {
            if let result = createResult(from: resultData) {
                results.append(result)
            }
        }

        let circuit = Circuit(circuitName: circuitName, location: Location(locality: locality, country: country))
        return Race(raceName: raceName, circuit: circuit, date: date, time: nil, results: results, laps: nil)
    }

    private static func createResult(from data: [String: Any]) -> Result? {
        // Extract commonly used values for improved readability
        let driverData = data["Driver"] as? [String: Any] ?? [:]
        let constructorData = data["Constructor"] as? [String: Any] ?? [:]
        let timeData = data["Time"] as? [String: Any] ?? [:]

        // Extract values using computed properties
        guard let number = data["number"] as? String,
              let position = data["position"] as? String,
              let positionText = data["positionText"] as? String,
              let points = data["points"] as? String,
              let driverId = driverData["driverId"] as? String,
              let driverUrl = driverData["url"] as? String,
              let givenName = driverData["givenName"] as? String,
              let familyName = driverData["familyName"] as? String,
              let dateOfBirth = driverData["dateOfBirth"] as? String,
              let nationality = driverData["nationality"] as? String,
              let constructorId = constructorData["constructorId"] as? String,
              let constructorUrl = constructorData["url"] as? String,
              let constructorName = constructorData["name"] as? String,
              let constructorNationality = constructorData["nationality"] as? String,
              let grid = data["grid"] as? String,
              let laps = data["laps"] as? String,
              let status = data["status"] as? String,
              let time = timeData["time"] as? String?
        else {
            print("CANT PROCESS? -\(data["grid"]!)")
            return nil
        }
        print("\(driverId)-\(grid) ")
        
        let driver = Driver(driverId: driverId, permanentNumber: nil, code: nil, url: driverUrl, givenName: givenName, familyName: familyName, dateOfBirth: dateOfBirth, nationality: nationality)
        let constructor = Constructor(constructorId: constructorId, url: constructorUrl, name: constructorName, nationality: constructorNationality)
       
        
        let timeValue = time ?? "N/A"
        let raceTime = Time(millis: "", time: timeValue)
        return Result(number: number, position: position, positionText: positionText, points: points, driver: driver, constructor: constructor, grid: grid, laps: laps, status: status, time: raceTime, fastestLap: nil)
    }

    static func allRaceSchedule(seasonYear: String, completion: @escaping (Bool) -> Void) {
        let url = "https://ergast.com/api/f1/\(seasonYear).json"
        guard let unwrappedURL = URL(string: url) else { return }
        // Check if data is cached
        if let cachedData = retrieveCachedData(for: seasonYear, queryKey: "raceSchedule") {
            do {
                let f1Data = try JSONSerialization.jsonObject(with: cachedData, options: []) as? [String: Any]

                if let mrData = f1Data?["MRData"] as? [String: Any],
                    let raceTable = mrData["RaceTable"] as? [String: Any],
                    let races = raceTable["Races"] as? [[String: Any]] {

                    for race in races {
                        if let raceName = race["raceName"] as? String,
                            let circuit = race["Circuit"] as? [String: Any],
                            let circuitName = circuit["circuitName"] as? String,
                            let location = circuit["Location"] as? [String: Any],
                            let country = location["country"] as? String,
                            let locality = location["locality"] as? String,
                            let date = race["date"] as? String,
                            let lat = location["lat"] as? String,
                            let long = location["long"] as? String {
                            
                            F1DataStore.circuitRaceDate.append(date)
                            F1DataStore.raceName.append(raceName)
                            F1DataStore.circuitID.append(circuit["circuitId"] as? String ?? "")
                            F1DataStore.circuitName.append(circuitName)
                            F1DataStore.circuitLocation.append(country)
                            F1DataStore.circuitCity.append(locality)
                            F1DataStore.circuitURL.append("https://en.wikipedia.org/wiki/\(circuitName.replacingOccurrences(of: " ", with: "_"))")
                            F1DataStore.circuitLatitude.append(lat)
                            F1DataStore.circuitLongitude.append(long)
                        }
                    }
                    print("RACE DATA LOADED FROM CACHE")
                    F1DataStore.cellCount = races.count - 1
                    completion(true)
                    return // Data is loaded from cache, so we're done
                }
            } catch {
                print("Error decoding cached JSON: \(error.localizedDescription)")
            }
        }

        // Data is not cached or cache is invalid, fetch from API
        URLSession.shared.dataTask(with: unwrappedURL) { (data, response, err) in
            guard let data = data else {
                completion(false)
                return
            }

            do {
                let f1Data = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                if let mrData = f1Data?["MRData"] as? [String: Any],
                    let raceTable = mrData["RaceTable"] as? [String: Any],
                    let races = raceTable["Races"] as? [[String: Any]] {

                    for race in races {
                        if let raceName = race["raceName"] as? String,
                            let circuit = race["Circuit"] as? [String: Any],
                            let circuitName = circuit["circuitName"] as? String,
                            let location = circuit["Location"] as? [String: Any],
                            let country = location["country"] as? String,
                            let locality = location["locality"] as? String,
                            let date = race["date"] as? String,
                            let lat = location["lat"] as? String,
                            let long = location["long"] as? String {
                            
                            F1DataStore.circuitRaceDate.append(date)
                            F1DataStore.raceName.append(raceName)
                            F1DataStore.circuitID.append(circuit["circuitId"] as? String ?? "")
                            F1DataStore.circuitName.append(circuitName)
                            F1DataStore.circuitLocation.append(country)
                            F1DataStore.circuitCity.append(locality)
                            F1DataStore.circuitURL.append("https://en.wikipedia.org/wiki/\(circuitName.replacingOccurrences(of: " ", with: "_"))")
                            F1DataStore.circuitLatitude.append(lat)
                            F1DataStore.circuitLongitude.append(long)
                            
                        }
                    }
                    F1DataStore.cellCount = races.count - 1

                    // Cache the data to UserDefaults
                    if let jsonData = try? JSONSerialization.data(withJSONObject: f1Data ?? [:], options: []) {
                        UserDefaults.standard.set(jsonData, forKey: "cache_raceSchedule_\(seasonYear)")
                    }

                    completion(true)
                } else {
                    print("Error: Invalid JSON structure")
                    completion(false)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
    
    static func worldDriversChampionshipStandings(seasonYear: String) async throws -> [DriverStanding] {
        if let cachedData = retrieveCachedData(for: seasonYear, queryKey: "worldDriversChampionshipStandings") {
            do {
                let json = try JSONSerialization.jsonObject(with: cachedData, options: []) as? [String: Any]
                return processDriverStandings(json, seasonYear: seasonYear)
            } catch {
                print("Error decoding the cached data \(error)")
                UserDefaults.standard.removeObject(forKey: "cache_worldDriversChampionshipStandings_\(seasonYear)")
            }
        } else {
            // if no cache was found lets make a network requerst
            guard let url = URL(string: "https://ergast.com/api/f1/\(seasonYear)/driverStandings.json") else {
                throw URLError(.badURL)
            }

            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if seasonYear != "2024" {
                UserDefaults.standard.set(data, forKey: "cache_worldDriversChampionshipStandings_\(seasonYear)")
            }

            return processDriverStandings(json, seasonYear: seasonYear)
        }
        return [DriverStanding(givenName: "", familyName: "", position: "", points: "", teamNames: "", imageUrl: "")]
    }

    static func processDriverStandings(_ json: [String: Any]?, seasonYear: String) -> [DriverStanding] {
        guard let mrData = json?["MRData"] as? [String: Any],
              let standingsTable = mrData["StandingsTable"] as? [String: Any],
              let standingsLists = standingsTable["StandingsLists"] as? [[String: Any]] else {
            return []
        }

        var results: [DriverStanding] = []
        var seenDrivers: Set<String> = Set()

        for standingsList in standingsLists {
            let driverStandings = standingsList["DriverStandings"] as? [[String: Any]] ?? []
            for driverStanding in driverStandings {
                if let driver = driverStanding["Driver"] as? [String: Any],
                   let givenName = driver["givenName"] as? String,
                   let familyName = driver["familyName"] as? String,
                   let position = driverStanding["position"] as? String,
                   let points = driverStanding["points"] as? String,
                   let constructors = driverStanding["Constructors"] as? [[String: Any]] {

                    let driverIdentifier = "\(givenName) \(familyName)"
                    
                    // Check if the driver has already been processed
                    if seenDrivers.contains(driverIdentifier) {
                        print("DRIVER SEEN < CONTINUE >")
                        continue
                    }

                    // Mark this driver as seen
                    seenDrivers.insert(driverIdentifier)

                    let teamNames = constructors.compactMap { $0["name"] as? String }.joined(separator: ", ")
                    let standing = DriverStanding(
                        givenName: givenName,
                        familyName: familyName,
                        position: position,
                        points: points,
                        teamNames: teamNames,
                        imageUrl: "")
                    results.append(standing)
                }
            }
        }
        print("RESULTS COUNT - \(results.count)")
        return results
    }

    
    static func fetchDriverImgFromWikipedia(givenName: String, familyName: String) async throws -> String {
        let encodedGivenName = givenName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let encodedFamilyName = familyName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let driverPageTitle = "\(encodedGivenName)_\(encodedFamilyName)"
        let cacheKey = "cache_driverImage_\(driverPageTitle)"

        // Check if image URL is cached
        if let cachedURL = UserDefaults.standard.string(forKey: cacheKey) {
            print("Using cached image URL for \(givenName) \(familyName): \(cachedURL)")
            return cachedURL
        }

        // Construct the URL for the Wikipedia API request
        let driverPageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(driverPageTitle)&prop=pageimages&format=json&pithumbsize=800"
        guard let url = URL(string: driverPageURLString) else {
            throw URLError(.badURL)
        }

        // Perform the network request
        let (data, _) = try await URLSession.shared.data(from: url)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)

        // Extract the thumbnail URL from the response
        guard let pageID = wikipediaData.query.pages.keys.first,
              let page = wikipediaData.query.pages[pageID],
              let thumbnailURL = page.thumbnail?.source else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response for \(givenName) \(familyName)"])
        }

        // Cache the thumbnail URL
        UserDefaults.standard.set(thumbnailURL, forKey: cacheKey)
        print("Fetched and cached image URL for \(givenName) \(familyName): \(thumbnailURL)")

        return thumbnailURL
    }

    // Fetch Race Results
    func fetchRaceResults(forYear year: String, round: String) async throws -> Root? {
        let urlString = "https://ergast.com/api/f1/\(year)/results/\(round).json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid response")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Root.self, from: data)
            print("[][][][][][][][][][][[][][][][][][][][][][][][][][]")
            print(decodedData)
            print("[][][][][][][][][][][[][][][][][][][][][][][][][][]")
            return decodedData
        } catch {
            print("Error decoding data: \(error)")
            throw error
        }
    }

    // Laps https://ergast.com/api/f1/2007/1/drivers/hamilton/laps
    // All drivers that have driven for a certain constructor
    // https://ergast.com/api/f1/constructors/mclaren/circuits/monza/drivers
    // https://ergast.com/api/f1/2024/21/drivers/hamilton/laps.json?limit=100
    // https://ergast.com/api/f1/current/constructorStandings.json?limit=100
    static func getLapTimes(seasonYear: String, round: Int, limit: Int = 5, driverId: String, completion: @escaping (Bool) -> Void) {
        let stringURL = "https://ergast.com/api/f1/\(seasonYear)/\(round)/drivers/\(driverId)/laps.json?limit=\(limit)"
        guard let url = URL(string: stringURL) else {
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(false)
                return
            }

            do {
                let root = try JSONDecoder().decode(Root.self, from: data)
                // Now you have the lap times in the root object
      
                if let races = root.mrData?.raceTable?.races, !races.isEmpty {
                    
                    for race in races {
                        print("\nRace: \(race.raceName ?? "Unknown Race")")
                        print("Circuit: \(race.circuit?.circuitName ?? "Unknown Circuit")")
                        print("Date: \(race.date ?? "Unknown Date")")
                        print("Time: \(race.time ?? "Unknown Time")")
                        
                        // Iterate over each lap
                        if let laps = race.laps {
                            for lap in laps {
                                if let timings = lap.timings {
                                    for timing in timings {
                                        F1DataStore.driversLaps.append("Lap \(lap.number ?? "Unknown") Driver: \(timing.driverId?.capitalized ?? "Unknown")\nPosition: \(timing.position ?? "Unknown")\nTime: \(timing.time ?? "Unknown")")
                                    }
                                }
                            }
                        }
                    }
                }
                // Process the data as needed
                completion(true)
            } catch {
                completion(false)
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
} // End F1APIRoutes
