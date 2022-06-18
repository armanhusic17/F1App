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
    
    // Driver Data
    static var driverNames:[String?] = []
    static var driverNationality:[String?] = []
    static var driverURL:[String?] = []
    static var driverNumber:[String?] = []
    static var driverFirstNames:[String?] = []
    static var driverDOB:[String?] = []
    
    // Circuit Data
    static var circuitID:[String?] = []
    static var circuitName:[String?] = []
    static var circuitLocation:[String?] = []
    static var circuitURL:[String?] = []
    
    static var cellIndexPassed:Int?
    
    static var whichQuery:Int?
    
    
}
