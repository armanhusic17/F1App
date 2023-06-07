//
//  DataModel.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import Formula1API

struct Data {

    // Team Data
    static var teamNames: [String?] = []
    static var teamNationality: [String?] = []
    static var teamURL: [String?] = []
    static var teamImgURL: [String?] = [] // <-- Add new property to hold team image URLs
    
    static var constructorID: [String?] = []

    // Driver Data
    static var driverNames: [String?] = []
    static var driverNationality: [String?] = []
    static var driverURL: [String?] = []
    static var driverNumber: [String?] = []
    static var driverFirstNames: [String?] = []
    static var driverDOB: [String?] = []
    static var driverCode: [String?] = []
    static var driverImgURL: [String?] = [] // <-- Add new property to hold driver image URLs

    // Cell Index
    static var cellIndexPassed: Int?

    // Circuit Data
    static var circuitID: [String?] = []
    static var circuitName: [String?] = []
    static var circuitLocation: [String?] = []
    static var circuitCity: [String?] = []
    static var circuitURL: [String?] = []
    static var circuitLongitude: [String?] = []
    static var circuitLatitude: [String?] = []
    static var circuitRaceDate: [String?] = []

    // Race Results
    static var raceName: [String?] = []
    static var raceDate: [String?] = []
    static var raceTime: [String?] = []
    static var raceURL: [String?] = []

    static var raceWins: [String?] = []
    static var racePosition: [String?] = []
    static var racePoints: [String?] = []
    static var raceWinnerName: [String?] = []
    static var raceWinnerTeam: [String?] = []

    static var qualiResults: [String?] = []

    // New Race Result
    static var fastestLap: [String?] = []
    static var rank: [String?] = []
    static var singleRaceName:String?
    // Wikipedia Images
    static var driverWikiImgURL: [String?] = [] // <-- Add new property to hold driver wiki image URLs
    static var teamWikiImgURL: [String?] = [] // <-- Add new property to hold team wiki image URLs

    // Cell Info
    static var whichQuery: Int?
    static var f1Season: [String?] = []

    static var seasonYearSelected: String?
    static var cellCount: Int?
    
    static var raceResults:[String?] = []
    static var driverChampionships: [(key: String, value: Int)] = []

    func removeAllCellData(){
        // Driver Data
        Data.driverNationality.removeAll()
        Data.driverURL.removeAll()
        Data.driverNames.removeAll()
        Data.driverFirstNames.removeAll()
        Data.driverDOB.removeAll()
        Data.driverNumber.removeAll()
        Data.driverCode.removeAll()
        Data.driverImgURL.removeAll()
        Data.driverWikiImgURL.removeAll()
        
        // Team Data
        Data.constructorID.removeAll()
        Data.teamURL.removeAll()
        Data.teamNames.removeAll()
        Data.teamNationality.removeAll()
        Data.teamImgURL.removeAll()
        // Circuit Data
        Data.circuitCity.removeAll()
        Data.circuitID.removeAll()
        Data.circuitName.removeAll()
        Data.circuitLocation.removeAll()
        Data.circuitURL.removeAll()
        
        // Circuit Data Continued
        Data.raceURL.removeAll()
        Data.raceTime.removeAll()
        Data.raceDate.removeAll()
        Data.raceName.removeAll()
        Data.f1Season.removeAll()
        
        Data.circuitLatitude.removeAll()
        Data.circuitLongitude.removeAll()
        
        Data.raceWins.removeAll()
        Data.racePoints.removeAll()
        Data.raceWinnerName.removeAll()
        Data.raceDate.removeAll()
        Data.circuitRaceDate.removeAll()
        Data.racePosition.removeAll()
        Data.raceWinnerTeam.removeAll()
        
        Data.qualiResults.removeAll()
        
        print("removed all data points from the arrays holding the cells")
    }
    
    
    

}



extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
