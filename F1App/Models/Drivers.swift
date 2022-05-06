//
//  Drivers.swift
//  F1App
//
//  Created by Arman Husic on 4/11/22.
//
//

import Foundation

/// Codable struct, used for serializing JSON from the Drivers endpoint.
public struct Drivers: Codable {
    public let data: DriversData

    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public struct DriversData: Codable {
    public let xmlns: String
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let driverTable: DriverTable

    private enum CodingKeys: String, CodingKey {
        case xmlns
        case series
        case url
        case limit
        case offset
        case total
        case driverTable = "DriverTable"
    }
}

public struct DriverTable: Codable {
    public let season:String?
    public let drivers: [Drivers]

    private enum CodingKeys: String, CodingKey {
        case season
        case drivers = "Drivers"
    }
}

public struct Driver: Codable {
    public let driverID: String
    public let code:String
    public let url:String
    public let givenName:String
    public let familyName:String
    public let dateOfBirth:String
    public let nationality:String
    public let permanentNumber:String

    
    private enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case code
        case url
        case givenName
        case familyName
        case dateOfBirth
        case nationality
        case permanentNumber
    }
}

