//
//  DataModel.swift
//  F1App
//
//  Created by Arman Husic on 4/12/22.
//

import Foundation

class Data  {
        
    // Team Data
    static var teamNames:[String?] = []
    static var teamNationality:[String?] = []
    static var teamURL:[String?] = []
    static var teamImgURL: [String?] = []
    
    // Driver Data
    static var driverNames:[String?] = []
    static var driverNationality:[String?] = []
    static var driverURL:[String?] = []
    static var driverNumber:[String?] = []
    static var driverFirstNames:[String?] = []
    static var driverDOB:[String?] = []
    
    
    // Cell Index
    static var cellIndexPassed:Int?
    
    // Determine Query - Team = 0; Driver = 1;
    static var whichQuery:Int?
    
    
}
