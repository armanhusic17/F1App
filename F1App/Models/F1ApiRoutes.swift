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
    
    
    // Query to get Last race result for homescreen
    static func getQualiResults(seasonYear:String){
        
        Formula1API.qualifyingResults(for: Season.year(Int(seasonYear) ?? 2022), limit: "3") { result in
            
            do {
                let racesData = try result.get().data.raceTable.races
                
                for i in Range(0...racesData.count - 1){
                    Data.raceName.append(racesData[i].raceName)
                    Data.raceTime.append(racesData[i].time)
                    Data.raceDate.append(racesData[i].date)
                    Data.qualiResults = racesData[i].qualifyingResults!
                    print(racesData[i].round)
                }
            } catch {
                print(error)
            }
            
        }
        
    }
    
    
    static func getStandings(seasonYear:String){
        Formula1API.driverStandings(for: Season.year(Int(seasonYear) ?? 2022), limit: "1") { result in
            do {
                let standings = try result.get().data.standingsTable
                
                for i in Range(0...standings.standingsLists.count - 1) {
                    Data.raceWins.append(standings.standingsLists[i].driverStandings[i].wins)
                }
                print(Data.raceWins)
            } catch {
                print("Error getting srandings")
            }
        }
    }
    
    
    //this can work as a seasons/circuits data
    static func getData(seasonYear:String){
        Formula1API.raceSchedule(for: Season.year(Int(seasonYear) ?? 2022)) { result in
            print(result)
            
            do {
                let f1Data = try result.get().data.raceTable.races
                
                for i in Range(0...f1Data.count - 1){
                    print(f1Data[i].raceName)
                    print(f1Data[i].date)
                    print(f1Data[i].circuit.location.locality)
                    print(f1Data[i].circuit.location.country)
                    print(f1Data[i].circuit.location.lat)
                    print(f1Data[i].circuit.location.long)



                }
                
                
            } catch {
                print("Error")
            }
        }
    }
    
    

 
    
}

/**
 
 https://ergast.com/api/f1/2008/results/1
 working on adding results that show up for drivers or teams or as a standalone not sure yet

 */
