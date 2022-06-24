//
//  DataModel.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation
import Formula1API

class Data  {
    // Team Data
    static var teamNames:[String?] = []
    static var teamNationality:[String?] = []
    static var teamURL:[String?] = []
    static var constructorID:[String?] = []
    // Driver Data
    static var driverNames:[String?] = []
    static var driverNationality:[String?] = []
    static var driverURL:[String?] = []
    static var driverNumber:[String?] = []
    static var driverFirstNames:[String?] = []
    static var driverDOB:[String?] = []
    static var driverCode:[String?] = []
    
    // Circuit Data
    static var circuitID:[String?] = []
    static var circuitName:[String?] = []
    static var circuitLocation:[String?] = []
    static var circuitURL:[String?] = []
    
    // Race Results Sara
    static var raceName:[String?] = []
    static var raceDate:[String?] = []
    static var raceTime:[String?] = []
    static var raceURL:[String?] = []
    
    // cell info
    static var cellIndexPassed:Int?
    static var whichQuery:Int?
    static var f1Season:[String?] = []
    
}
