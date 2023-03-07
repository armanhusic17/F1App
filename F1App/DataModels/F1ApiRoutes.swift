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
    
    // Drivers
    static func allDrivers(seasonYear:String){
        let url = "https://ergast.com/api/f1/\(seasonYear)/drivers.json"

        guard let unwrappedURL = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: unwrappedURL) { (data, response, err) in
                    
            guard let data = data else {return}

            do {
                let f1Data = try JSONDecoder().decode(Drivers.self, from: data)
                let driversTableArray = f1Data.data.driverTable.drivers
                for i in Range(0...driversTableArray.count - 1) {
                    Data.driverNames.append(driversTableArray[i].familyName)
                    Data.driverNationality.append(driversTableArray[i].nationality)
                    Data.driverURL.append(driversTableArray[i].url)
                    Data.driverNumber.append(driversTableArray[i].permanentNumber)
                    Data.driverFirstNames.append(driversTableArray[i].givenName)
                    Data.driverDOB.append(driversTableArray[i].dateOfBirth)
                    Data.driverCode.append(driversTableArray[i].code)
                }
                
            } catch  {
                print("Error decoding DRIVERS json data ")
            }
        }.resume()
    }
    
    // Constructors
    static func allConstructors(seasonYear:String) {
        let url = "https://ergast.com/api/f1/\(seasonYear)/constructors.json"
        
        guard let unwrappedURL = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: unwrappedURL) { (data, response, err) in
                    
            guard let data = data else {return}
            
            do {
                let f1Data = try JSONDecoder().decode(Constructors.self, from: data)
                let thisArray = f1Data.data.constructorTable.constructors
                let season = f1Data.data.constructorTable.season?.capitalized
            
                for i in Range(0...thisArray.count - 1){
                    Data.teamNames.append(thisArray[i].name)
                    Data.teamNationality.append(thisArray[i].nationality)
                    Data.teamURL.append(thisArray[i].url)
                    Data.constructorID.append(thisArray[i].constructorID)
                    Data.f1Season.append(season)
                    
                }
            } catch  {
                print("Error decoding CONSTRUCTOR json data ")
            }
        }.resume()
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
    

    
    
    static func getStandings(seasonYear:String){
        Formula1API.driverStandings(for: Season.year(Int(seasonYear) ?? 0)) { result in
            do {
                let standings = try result.get().data.standingsTable
                for i in Range(0...standings.standingsLists.count - 1) {
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWins.append(standings.standingsLists[i].driverStandings[i].wins)
                    Data.racePoints.append(standings.standingsLists[i].driverStandings[i].points)
                    Data.raceWinnerName.append(standings.standingsLists[i].driverStandings[i].driver.familyName)
                    Data.raceWinnerTeam.append(standings.standingsLists[i].driverStandings[i].constructors[i].name)
                    

                }
            } catch {
                print("Error getting srandings")
            }
        }
        Formula1API.driverStandings(for: Season.year(Int(seasonYear) ?? 0), limit: "1") { result in
            do {
                let standings = try result.get().data.standingsTable
                for i in Range(0...standings.standingsLists.count - 1) {
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWins.append(standings.standingsLists[i].driverStandings[i].wins)
                    Data.racePoints.append(standings.standingsLists[i].driverStandings[i].points)
                    Data.raceWinnerName.append(standings.standingsLists[i].driverStandings[i].driver.familyName)
                    Data.raceWinnerTeam.append(standings.standingsLists[i].driverStandings[i].constructors[i].name)


                }
            } catch {
                print("Error getting srandings")
            }
        }

        Formula1API.driverStandings(for: Season.year(Int(seasonYear) ?? 0), limit: "2") { result in
            do {
                let standings = try result.get().data.standingsTable
                for i in Range(0...standings.standingsLists.count - 1) {
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWins.append(standings.standingsLists[i].driverStandings[i].wins)
                    Data.racePoints.append(standings.standingsLists[i].driverStandings[i].points)
                    Data.raceWinnerName.append(standings.standingsLists[i].driverStandings[i].driver.familyName)
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWinnerTeam.append(standings.standingsLists[i].driverStandings[i].constructors[i].name)
                }
            } catch {
                print("Error getting srandings")
            }
        }
        Formula1API.driverStandings(for: Season.year(Int(seasonYear) ?? 0), limit: "3") { result in
            do {
                let standings = try result.get().data.standingsTable
                for i in Range(0...standings.standingsLists.count - 1) {
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWins.append(standings.standingsLists[i].driverStandings[i].wins)
                    Data.racePoints.append(standings.standingsLists[i].driverStandings[i].points)
                    Data.raceWinnerName.append(standings.standingsLists[i].driverStandings[i].driver.familyName)
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWinnerTeam.append(standings.standingsLists[i].driverStandings[i].constructors[i].name)
                }
            } catch {
                print("Error getting srandings")
            }
        }
        Formula1API.driverStandings(for: Season.year(Int(seasonYear) ?? 0), limit: "4") { result in
            do {
                let standings = try result.get().data.standingsTable
                for i in Range(0...standings.standingsLists.count - 1) {
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWins.append(standings.standingsLists[i].driverStandings[i].wins)
                    Data.racePoints.append(standings.standingsLists[i].driverStandings[i].points)
                    Data.raceWinnerName.append(standings.standingsLists[i].driverStandings[i].driver.familyName)
                    print(standings.standingsLists[i].driverStandings[i])
                    Data.raceWinnerTeam.append(standings.standingsLists[i].driverStandings[i].constructors[i].name)
                }
            } catch {
                print("Error getting srandings")
            }
        }
    }
    
    // Results
    // Drivers
    static func testResults(seasonYear:String, position:String){
        
        let url = "https://ergast.com/api/f1/\(seasonYear)/results/\(position).json"

        guard let unwrappedURL = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: unwrappedURL) { (data, response, err) in
                    
            guard let data = data else {return}

            do {
                let f1Data = try JSONDecoder().decode(RaceResults.self, from: data)

                for i in Range(0...f1Data.data.raceTable.races.count - 1){
                  
                    print(f1Data.data.raceTable.races[i])
                    
                    
                }


                
            } catch  {
                print("Error decoding FINISHING STATUS QUERY json data ")
            }
        }.resume()
    }
    
    
   
    
    

 
    
}

/**
 
 https://ergast.com/api/f1/2008/results/1
 working on adding results that show up for drivers or teams or as a standalone not sure yet

 */
