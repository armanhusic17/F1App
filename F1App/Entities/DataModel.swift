//
//  DataModel.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation

struct F1DataStore {
    // Team Data
    static var teamNames: [String?] = []
    static var teamNationality: [String?] = []
    static var teamURL: [String?] = []
    static var teamImgURL: [String?] = [] // <-- Add new property to hold team image URLs
    static var teamImages = [String: String]() // Dictionary where the key is the team name and the value is the image URL
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
    static var driverTotalStarts: [Int?] = []
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
    static var driverLastName: [String?] = []
    static var driverFinishes: [String?] = []
    static var driverPoles: [String?] = []
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
    static var seasonRound:Int?
    static var cellCount: Int?
    static var raceResults:[String?] = []
    static var driverChampionships: [(key: String, value: Int)] = []
    static var driversLaps:[String] = []
    
    func removeAllCellData(){
        // Driver Data
        F1DataStore.driverNationality.removeAll()
        F1DataStore.driverURL.removeAll()
        F1DataStore.driverNames.removeAll()
        F1DataStore.driverFirstNames.removeAll()
        F1DataStore.driverDOB.removeAll()
        F1DataStore.driverNumber.removeAll()
        F1DataStore.driverCode.removeAll()
        F1DataStore.driverImgURL.removeAll()
        F1DataStore.driverWikiImgURL.removeAll()
        // Team Data
        F1DataStore.constructorID.removeAll()
        F1DataStore.teamURL.removeAll()
        F1DataStore.teamNames.removeAll()
        F1DataStore.teamNationality.removeAll()
        F1DataStore.teamImgURL.removeAll()
        // Circuit Data
        F1DataStore.circuitCity.removeAll()
        F1DataStore.circuitID.removeAll()
        F1DataStore.circuitName.removeAll()
        F1DataStore.circuitLocation.removeAll()
        F1DataStore.circuitURL.removeAll()
        // Circuit Data Continued
        F1DataStore.raceURL.removeAll()
        F1DataStore.raceTime.removeAll()
        F1DataStore.raceDate.removeAll()
        F1DataStore.raceName.removeAll()
        F1DataStore.f1Season.removeAll()
        F1DataStore.circuitLatitude.removeAll()
        F1DataStore.circuitLongitude.removeAll()
        F1DataStore.raceWins.removeAll()
        F1DataStore.racePoints.removeAll()
        F1DataStore.raceWinnerName.removeAll()
        F1DataStore.raceDate.removeAll()
        F1DataStore.circuitRaceDate.removeAll()
        F1DataStore.racePosition.removeAll()
        F1DataStore.raceWinnerTeam.removeAll()
        F1DataStore.qualiResults.removeAll()
        print("removed all data points from the arrays holding the cells")
    }
}

extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
