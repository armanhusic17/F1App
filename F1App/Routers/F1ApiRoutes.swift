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

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
            
            if let pageID = wikipediaData.query.pages.keys.first,
               let page = wikipediaData.query.pages[pageID],
               let thumbnailURL = page.thumbnail?.source {
                print(thumbnailURL)
                return thumbnailURL
            }
        } catch {
            print("Direct query failed: \(error)")
        }
        
        // Fallback to search if direct query didn't return an image
        return try await fetchConstructorImage(constructorName: constructorName)
    }
        
    static func fetchConstructorImage(constructorName: String) async throws -> String {
        let query = constructorName.addingPercentEncodingForWikipedia()
        let searchURLStr = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(query)&format=json"

        guard let searchURL = URL(string: searchURLStr) else {
            throw ImageFetchError.invalidURL
        }

        let (searchData, _) = try await URLSession.shared.data(from: searchURL)
        let searchResults = try JSONDecoder().decode(WikipediaSearchData.self, from: searchData)

        guard let firstResult = searchResults.query.search.first else {
            throw ImageFetchError.dataError(description: "No search results found for \(constructorName)")
        }

        let pageID = firstResult.pageid
        let pageURLStr = "https://en.wikipedia.org/w/api.php?action=query&pageids=\(pageID)&prop=pageimages&format=json&pithumbsize=800"

        guard let pageURL = URL(string: pageURLStr) else {
            throw ImageFetchError.invalidURL
        }

        let (pageData, _) = try await URLSession.shared.data(from: pageURL)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: pageData)
        
        guard let page = wikipediaData.query.pages["\(pageID)"],
              let thumbnailURL = page.thumbnail?.source else {
            throw ImageFetchError.dataError(description: "No image found for \(constructorName)")
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

    // Fetch list of races for a specific year
    func fetchRaceSchedule(forYear year: String) async throws -> Root? {
        let urlString = "https://ergast.com/api/f1/\(year).json"
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

            return decodedData
        } catch {
            print("Error decoding data: \(error)")
            throw error
        }
    }

    // https://ergast.com/api/f1/2009/4/results.json
    func fetchRaceResults(forYear seasonYear: String, round: String) async throws -> RaceResults? {
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/\(round)/results.json"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }

        let cacheKey = urlString

        if let cachedData = UserDefaults.standard.data(forKey: cacheKey) {
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(RaceResults.self, from: cachedData)
                return decodedData
            } catch {
                print("Error decoding cached data \(error)")
            }
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Invalid Response")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(RaceResults.self, from: data)

            UserDefaults.standard.set(data, forKey: cacheKey)
            return decodedData
        } catch {
            print("Error decoding data: \(error)")
            throw error
        }
        
    }


} // End F1APIRoutes

enum ImageFetchError: Error {
    case invalidURL
    case dataError(description: String)
}

extension String {
    func addingPercentEncodingForWikipedia() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
