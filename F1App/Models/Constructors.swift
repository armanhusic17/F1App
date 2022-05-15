//
//  Constructors.swift
//  F1App
//
//  Created by Arman Husic on 4/11/22.
//

import Foundation

public struct Constructors: Codable {
    public let data: ConstructorsData

    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public struct ConstructorsData: Codable {
    public let xmlns: String
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let constructorTable: ConstructorTable

    private enum CodingKeys: String, CodingKey {
        case xmlns
        case series
        case url
        case limit
        case offset
        case total
        case constructorTable = "ConstructorTable"
    }
}

public struct ConstructorTable: Codable {
    public let season: String?
    public var constructors: [Constructor]

    private enum CodingKeys: String, CodingKey {
        case season
        case constructors = "Constructors"
    }
}

public struct Constructor: Codable {
    public let constructorID: String
    public let url: String
    public let name: String
    public let nationality: String

    private enum CodingKeys: String, CodingKey {
        case constructorID = "constructorId"
        case url
        case name
        case nationality
    }
}





