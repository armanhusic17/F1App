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

    static var qualiResults: [QualifyingResult] = []

    // New Race Result
    static var fastestLap: [String?] = []
    static var rank: [String?] = []

    // Wikipedia Images
    static var driverWikiImgURL: [String?] = [] // <-- Add new property to hold driver wiki image URLs
    static var teamWikiImgURL: [String?] = [] // <-- Add new property to hold team wiki image URLs

    // Cell Info
    static var whichQuery: Int?
    static var f1Season: [String?] = []

    static var seasonYearSelected: String?
    static var cellCount: Int?

    struct User {

        let username: String?
        let signUpDate: Date?
        var favTeam: String?
        var favDriver: String?

        init(myUserName: String, mySignUpDate: Date, myFavTeam: String, myFavDriver: String) {
            username = myUserName
            signUpDate = mySignUpDate
            favTeam = myFavTeam
            favDriver = myFavDriver
        }
    }
}



extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
