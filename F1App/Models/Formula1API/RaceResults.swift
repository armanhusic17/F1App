//
//  RaceResults.swift
//  F1App
//
//  Created by Arman Husic on 6/22/22.
//


import Foundation

/// Codable struct, used for serializing JSON from the RaceResults endpoint.
public struct RaceResults: Codable {
    public let data: RaceResultsData

    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public struct RaceResultsData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let raceResult: RaceResult

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case raceResult = "RaceResult"
    }
}

public struct RaceResult: Codable {
    public let number: String
    public let position: String
    public let points: String
    public let driver: [Driver]
    public let constructor: [Constructor]
    public let grid, laps, status: String
    public let time: Time?
    public let fastestLap: FastestLap

    private enum CodingKeys: String, CodingKey {
        case number
        case position
        case points
        case driver = "Driver"
        case constructor = "Constructor"
        case grid, laps, status
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}


public struct FastestLap: Codable {
    public let rank: String
    public let lap: String
    public let time: FastestLapTime
    public let averageSpeed: AverageSpeed

    private enum CodingKeys: String, CodingKey {
        case rank
        case lap
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

public struct AverageSpeed: Codable {
    public let units: Units
    public let speed: String
}

public enum Units: String, Codable {
    case kph = "kph"
}

public struct FastestLapTime: Codable {
    public let time: String
}

public struct Time: Codable {
    public let millis: String
    public let time: String
}

/**
 
 
 */
