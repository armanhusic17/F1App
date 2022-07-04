//
//  Drivers.swift
//  F1App
//
//  Created by Arman Husic on 4/11/22.
//
//

import Foundation

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


public struct Driver: Codable {
    public let driverID: String
    public let permanentNumber: String?
    public let code: String?
    public let url: String
    public let givenName: String
    public let familyName: String
    public let dateOfBirth: String
    public let nationality: String

    private enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case permanentNumber
        case code
        case url
        case givenName
        case familyName
        case dateOfBirth
        case nationality
    }
}

public struct DriverTable: Codable {
    public let season:String?
    public let drivers: [Driver]

    private enum CodingKeys: String, CodingKey {
        case season
        case drivers = "Drivers"
    }
}



