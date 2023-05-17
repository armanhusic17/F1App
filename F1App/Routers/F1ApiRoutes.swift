//
//  F1Data_Model.swift
//  F1App
//
//  Created by Arman Husic on 3/23/22.
//

import Foundation
import UIKit
import SwiftyJSON
import Formula1API


/**
    Here we will  set up some routes to the ergast api
    Set up a struct that can decode the json return by ergast

 */




struct F1ApiRoutes  {
    
    let myData = Data()
    
    static func allRaceResults(seasonYear: String) {
        print(seasonYear)

        let urlString = "https://ergast.com/api/f1/\(seasonYear)/results.json"
        guard let url = URL(string: urlString) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10 // set timeout to 10 seconds
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                let raceResults = try JSONDecoder().decode(RaceResults.self, from: data)
                for race in raceResults.mrData.raceTable.races {
                    print(raceResults.mrData.raceTable.races.count)
                    print("+++++++++++++++++++++++++++++")
                    print("Race \(race.raceName)")
                    print(race.circuit)
                    print(race.date)
                    print("+++++++++++++++++++++++++++++")

                    for result in race.results {
                        print("----------------------")
                        print("----------------------")
                        print("Driver: \(result.driver)")
                        print("Position: \(result.position)")
                        print("Points: \(result.points)")
                        print("Constructor: \(result.constructor)")
                        print("Status: \(result.status)")
                        print("Fastest Lap: \(result.fastestLap)")
                        print("Grid: \(result.grid)")
                        print("Laps: \(result.laps)")
                        print("Time: \(result.time)")
                        print("----------------------")
                        print("----------------------")
                    }
                }
            } catch let error {
                print("Error decoding race results: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    
    static func singleRaceResults(seasonYear: Int, roundNumber: Int){
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/\(roundNumber + 1)/results.json"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("Error: No data received")
                    return
                }
                
                // Data received successfully
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print("JSON response: \(json)")

                    // TODO: Process the JSON response as needed
                    // Assuming that `data` contains the JSON data received from the API

                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let mrData = json["MRData"] as? [String: Any],
                        let raceTable = mrData["RaceTable"] as? [String: Any],
                        let races = raceTable["Races"] as? [[String: Any]] {

                        for race in races {
                            let results = race["Results"] as? [[String: Any]] ?? []
                            for result in results {
                                let driver = result["Driver"] as? [String: Any] ?? [:]
                                let constructor = result["Constructor"] as? [String: Any] ?? [:]
                                let position = result["position"] as? String ?? ""
                                let fastestLap = result["FastestLap"] as? [String: Any] ?? [:]
                                let lapTimeData = fastestLap["Time"] as? [String: Any] ?? [:]
                                let lapTime = lapTimeData["time"] as? String ?? ""
                                let topSpeedData = fastestLap["AverageSpeed"] as? [String: Any] ?? [:]
                                let topSpeed = topSpeedData["speed"] as? String ?? ""

                                let driverName = "\(driver["givenName"] ?? "") \(driver["familyName"] ?? "")"
                                let constructorName = constructor["name"] as? String ?? ""

                                print("Driver: \(driverName), Constructor: \(constructorName), Position: \(position), Fastest Lap Time: \(lapTime), Top Speed: \(topSpeed)")
                                Data.driverNames.append(driverName)
                                Data.constructorID.append(constructorName)
                                Data.racePosition.append(position)
                                Data.fastestLap.append(lapTime)
                                Data.raceTime.append(topSpeed)
                            }
                        }
                    } else {
                        print("Error: Invalid JSON structure")
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }


            }
            
            task.resume()
        } else {
            print("Error: Invalid URL")
        }
    }

    
    
    // Drivers
    static func allDrivers(seasonYear: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/drivers.json"
        guard let url = URL(string: urlString) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30 // set timeout to 10 seconds
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                print("Error: No data received")
                return
            }

            do {
                let f1Data = try JSONDecoder().decode(Drivers.self, from: data)
                let driversTableArray = f1Data.data.driverTable.drivers
                
                for driver in driversTableArray {
                    let driverPageTitle = "\(driver.givenName)_\(driver.familyName)"
                    let driverPageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(driverPageTitle)&prop=pageimages&format=json&pithumbsize=500"
                    guard let driverPageURL = URL(string: driverPageURLString) else { continue }
                    
                    URLSession.shared.dataTask(with: driverPageURL) { (data, response, error) in
                        guard let data = data else { return }
                        do {
                            let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
                            guard let pageID = wikipediaData.query.pages.keys.first,
                                  let thumbnail = wikipediaData.query.pages[pageID]?.thumbnail else { return }
                            let thumbnailURLString = thumbnail.source
                            
                            DispatchQueue.main.async {
                                if let number = driver.permanentNumber {
                                    let tuple = (number, thumbnailURLString)
                                    let string = "\(tuple.0),\(tuple.1)"
                                    Data.driverImgURL.append(string)
                                    Data.driverNames.append(driver.familyName)
                                    Data.driverNationality.append(driver.nationality)
                                    Data.driverURL.append(driver.url)
                                    Data.driverNumber.append(driver.permanentNumber)
                                    Data.driverFirstNames.append(driver.givenName)
                                    Data.driverDOB.append(driver.dateOfBirth)
                                    Data.driverCode.append(driver.code)
                                 
                                }
                            }
                        } catch let error {
                            print("Error decoding Wikipedia JSON data: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        }
                    }.resume()
                }
               
            } catch let error {
                print("Error decoding DRIVERS json data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }

        task.resume()
        
        DispatchQueue.main.async {
            completion(true)
        }
    }
    

    static func allDriversBefore2014(seasonYear: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/drivers.json"
        guard let url = URL(string: urlString) else { return }
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 59 // set timeout to 10 seconds
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error: No data received")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            do {
                Data.whichQuery = 1 // Set the query type to drivers

                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(json) // Print the entire API response
                
                let driversTable = json?["MRData"] as? [String: Any]
                let driversTableArray = driversTable?["DriverTable"] as? [String: Any]
                let drivers = driversTableArray?["Drivers"] as? [[String: Any]]
                
                for driver in drivers ?? [] {
                    print(driver)
                    guard let givenName = driver["givenName"] as? String,
                    let familyName = driver["familyName"] as? String,
                          let nationality = driver["nationality"] as? String else { continue }
//                    let permanentNumber = driver["permanentNumber"] as? String,
//                    let url = driver["url"] as? String else { continue }
                    // Append driver information to array
                    Data.driverFirstNames.append(givenName)
                    Data.driverNames.append(familyName)
                    Data.driverNationality.append(nationality)
//                    Data.driverURL.append(url)
//                    Data.driverNumber.append(permanentNumber)
                    
                    
                }
                
                completion(true)
            } catch let error {
                print("Error decoding DRIVERS json data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        task.resume()
    }

    
    
//    static func allDriversBefore2014(seasonYear: String, completion: @escaping (Bool) -> Void) {
//        let urlString = "https://ergast.com/api/f1/\(seasonYear)/drivers.json"
//        guard let url = URL(string: urlString) else { return }
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 30 // set timeout to 10 seconds
//        let session = URLSession(configuration: sessionConfig)
//        let task = session.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                print("Error: No data received")
//                DispatchQueue.main.async {
//                    completion(false)
//                }
//                return
//            }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                let driversTable = json?["MRData"] as? [String: Any]
//                let driversTableArray = driversTable?["DriverTable"] as? [String: Any]
//                let drivers = driversTableArray?["Drivers"] as? [[String: Any]]
//
//                let group = DispatchGroup() // Create a dispatch group
//
//                for driver in drivers ?? [] {
//                    guard let givenName = driver["givenName"] as? String,
//                        let familyName = driver["familyName"] as? String,
//                        let nationality = driver["nationality"] as? String,
//                        let permanentNumber = driver["permanentNumber"] as? String,
//                        let url = driver["url"] as? String else { continue }
//
//                    let driverPageTitle = "\(givenName)_\(familyName)"
//                    print(driverPageTitle)
//                    let driverPageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(driverPageTitle)&prop=pageimages&format=json&pithumbsize=500"
//                    guard let driverPageURL = URL(string: driverPageURLString) else { continue }
//
//                    group.enter() // Notify the group that a task has started
//
//                    URLSession.shared.dataTask(with: driverPageURL) { (data, response, error) in
//                        defer {
//                            group.leave() // Notify the group that the task has finished
//                        }
//
//                        guard let data = data,
//                            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                            let query = json["query"] as? [String: Any],
//                            let pages = query["pages"] as? [String: Any] else { return }
//
//                        for (_, pageData) in pages {
//                            guard let page = pageData as? [String: Any],
//                                let thumbnail = page["thumbnail"] as? [String: Any],
//                                let imageURLString = thumbnail["source"] as? String else { continue }
//
//                            // Append driver image URL and number to array
//                            let string = "\(permanentNumber),\(imageURLString)"
//                            Data.driverImgURL.append(string)
//                            Data.driverFirstNames.append(givenName)
//                            Data.driverNames.append(familyName)
//                            Data.driverNationality.append(nationality)
//                            Data.driverURL.append(url)
//                            Data.driverNumber.append(permanentNumber)
//
//                            print(Data.driverImgURL)
//                            print(Data.driverFirstNames)
//                            print(Data.driverNames)
//                         }
//
//                     }.resume()
//                 }
//
//                 group.notify(queue: .main) {
//                     completion(true) // Call the completion block after all tasks have finished
//                 }
//             } catch let error {
//                 print("Error decoding DRIVERS json data: \(error.localizedDescription)")
//                 DispatchQueue.main.async {
//                     completion(false)
//                 }
//             }
//         }
//         task.resume()
//    }



    
    // Constructors
    static func allConstructors(seasonYear: String) {
        let urlString = "https://ergast.com/api/f1/\(seasonYear)/constructors.json"

        guard let url = URL(string: urlString) else { return }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10 // set timeout to 10 seconds

        let session = URLSession(configuration: sessionConfig)

        let task = session.dataTask(with: url) { (data, response, error) in

            guard let data = data else {
                print("Error: No data received")
                return
            }

            do {
                let f1Data = try JSONDecoder().decode(Constructors.self, from: data)
                let constructorTable = f1Data.data.constructorTable
                let constructorsArray = constructorTable.constructors
                let season = constructorTable.season?.capitalized
                
                for constructor in constructorsArray {
                    let constructorPageTitle = constructor.name.replacingOccurrences(of: " ", with: "_")
                    let constructorPageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(constructorPageTitle)&prop=pageimages&format=json&pithumbsize=500"
                    guard let constructorPageURL = URL(string: constructorPageURLString) else { continue }
                    
                    URLSession.shared.dataTask(with: constructorPageURL) { (data, response, error) in
                        guard let data = data else { return }
                        do {
                            let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
                            guard let pageID = wikipediaData.query.pages.keys.first,
                                  let thumbnail = wikipediaData.query.pages[pageID]?.thumbnail else {
                                DispatchQueue.main.async {
                                    Data.teamImgURL.append("\(constructor.constructorID),default")
                                    Data.teamNames.append(constructor.name)
                                    Data.teamNationality.append(constructor.nationality)
                                    Data.teamURL.append(constructor.url)
                                    Data.constructorID.append(constructor.constructorID)
                                    Data.f1Season.append(season)
                                }
                                return
                            }
                            let thumbnailURLString = thumbnail.source
                            
                            DispatchQueue.main.async {
                                let tuple = (constructor.constructorID, thumbnailURLString)
                                let string = "\(tuple.0),\(tuple.1)"
                                Data.teamImgURL.append(string)
                                Data.teamNames.append(constructor.name)
                                Data.teamNationality.append(constructor.nationality)
                                Data.teamURL.append(constructor.url)
                                Data.constructorID.append(constructor.constructorID)
                                Data.f1Season.append(season)
                            }
                        } catch let error {
                            print("Error decoding Wikipedia JSON data: \(error.localizedDescription)")
                        }
                    }.resume()
                }
            } catch let error {
                print("Error decoding CONSTRUCTORS json data: \(error.localizedDescription)")
            }
        }

        task.resume()
    }



    
    // Circuits
    static func allCircuits(seasonYear:String){
            let url = "https://ergast.com/api/f1/\(seasonYear)/circuits.json"

            guard let unwrappedURL = URL(string: url) else {return}

            URLSession.shared.dataTask(with: unwrappedURL) { (data, response, err) in

                guard let data = data else {return}

                do {
                    let f1Data = try JSONDecoder().decode(Circuits.self, from: data)
                    let thisArray = f1Data.data.circuitTable.circuits

                    let thisCount = thisArray.count - 1
                    Data.cellCount = thisCount
                    if thisCount >= 0 {

                        for i in Range(0...thisCount){
                            Data.circuitName.append(thisArray[i].circuitName)
                            Data.circuitID.append(thisArray[i].circuitID)
                            Data.circuitLocation.append(thisArray[i].location.country)
                            Data.circuitCity.append(thisArray[i].location.locality)

                            Data.circuitURL.append("https://en.wikipedia.org/wiki/\(thisArray[i].circuitName.replacingOccurrences(of: " ", with: "_"))")
                            Data.circuitLatitude.append(thisArray[i].location.lat)
                            Data.circuitLongitude.append(thisArray[i].location.long)
                        }
                    }

                } catch  {
                    print("Error decoding CIRCUIT json data ")
                }
            }.resume()
            
    }
    
    
    static func allCircuitsAfter2004(seasonYear:String){
        Formula1API.raceSchedule(for: Season.year(Int(seasonYear) ?? 0)) { result in
        print(result)
        
        do {
            let f1Data = try result.get().data.raceTable.races
            
            for i in Range(0...f1Data.count - 1){
                Data.circuitID.append(f1Data[i].circuit.circuitID)
                Data.circuitName.append(f1Data[i].raceName)
                Data.circuitRaceDate.append(f1Data[i].date)
                Data.circuitURL.append("https://en.wikipedia.org/wiki/\(f1Data[i].circuit.circuitName.replacingOccurrences(of: " ", with: "_"))")

                Data.circuitCity.append(f1Data[i].circuit.location.locality)
                Data.circuitLocation.append(f1Data[i].circuit.location.country)
                Data.circuitLatitude.append(f1Data[i].circuit.location.lat)
                Data.circuitLongitude.append(f1Data[i].circuit.location.long)

            }
            Data.cellCount = f1Data.count - 1

        } catch {
            print("Error")
        }
    }
    }
    
    
    // Query to get Last race result for homescreen
    static func getQualiResults(seasonYear:String, round: String){
        Formula1API.qualifyingResults(for: Season.year(Int(seasonYear) ?? 2022), round: round, limit: "10") { result in
            
            do {
                let racesData = try result.get().data.raceTable.races
                
                for i in Range(0...racesData.count - 1){
                    Data.qualiResults = racesData[i].qualifyingResults!
                    Data.raceName = [(racesData[i].raceName)]
                    
                    print(racesData[i].raceName)
                }
            } catch {
                print(error)
            }
            
        }
    }
    

    
    

}


struct WikipediaImage: Decodable {
    let source: String
}

struct WikipediaData: Decodable {
    let query: WikipediaQuery
}

struct WikipediaQuery: Decodable {
    let pages: [String: WikipediaPage]
}

struct WikipediaPage: Decodable {
    let thumbnail: WikipediaThumbnail?
    let originalimage: WikipediaImage?
}

struct WikipediaThumbnail: Decodable {
    let source: String
}

/**
 
 https://ergast.com/api/f1/2008/results/1
 working on adding results that show up for drivers or teams or as a standalone not sure yet

 */

struct Time: Decodable {
    let millis: String
    let time: String
    
    private enum CodingKeys: String, CodingKey {
        case millis, time
    }
}

struct RaceResults: Decodable {
    let mrData: MRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRData: Decodable {
    let raceTable: RaceTable
    
    private enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

struct RaceTable: Decodable {
    let races: [Race]
    let season: String
    
    private enum CodingKeys: String, CodingKey {
        case races = "Races"
        case season = "season"
    }
}

struct Race: Decodable {
    let raceName: String
    let circuit: Circuit
    let date: String
    let results: [Result]
    
    private enum CodingKeys: String, CodingKey {
        case raceName = "raceName"
        case circuit = "Circuit"
        case date = "date"
        case results = "Results"
    }
}

struct Circuit: Decodable {
    let circuitName: String
    let location: Location
    
    private enum CodingKeys: String, CodingKey {
        case circuitName = "circuitName"
        case location = "Location"
    }
}

struct Location: Decodable {
    let locality: String
    let country: String
    
    private enum CodingKeys: String, CodingKey {
        case locality = "locality"
        case country = "country"
    }
}

struct Result: Decodable {
    let number: String
    let position: String
    let positionText: String
    let points: String
    let driver: Driver
    let constructor: Constructor
    let grid: String
    let laps: String
    let status: String
    let time: Time?
    let fastestLap: FastestLap?
    
    private enum CodingKeys: String, CodingKey {
        case number = "number"
        case position = "position"
        case positionText = "positionText"
        case points = "points"
        case driver = "Driver"
        case constructor = "Constructor"
        case grid = "grid"
        case laps = "laps"
        case status = "status"
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}

struct Driver: Decodable {
    let driverId: String
    let permanentNumber: String?
    let code: String?
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    
    private enum CodingKeys: String, CodingKey {
        case driverId = "driverId"
        case permanentNumber = "permanentNumber"
        case code = "code"
        case url = "url"
        case givenName = "givenName"
        case familyName = "familyName"
        case dateOfBirth = "dateOfBirth"
        case nationality = "nationality"
    }
}

struct Constructor: Decodable {
    let constructorId: String
    let url: String
    let name: String
    let nationality: String
    
    private enum CodingKeys: String, CodingKey {
        case constructorId = "constructorId"
        case url = "url"
        case name = "name"
        case nationality = "nationality"
    }
}
