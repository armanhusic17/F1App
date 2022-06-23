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
    public let raceTable: RaceTable

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case raceTable = "RaceTable"
    }
}

public struct RaceResult: Codable {
    public let number: String
    public let position: String
    public let positionText: String
    public let points: String
    public let driver: Driver
    public let constructor: Constructor
    public let grid, laps, status: String
    public let time: ResultTime?
    public let fastestLap: FastestLap

    private enum CodingKeys: String, CodingKey {
        case number
        case position
        case positionText
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

public struct ResultTime: Codable {
    public let millis: String
    public let time: String
}


public struct RaceScheduleData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let raceTable: RaceTable

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case raceTable = "RaceTable"
    }
}

public struct RaceTable: Codable {
    public let season: String
    public let round: String?
    public let races: [Race]

    private enum CodingKeys: String, CodingKey {
        case season
        case round
        case races = "Races"
    }
}

public struct Race: Codable {
    public let season: String
    public let round: String
    public let url: String
    public let raceName: String
    public let circuit: Circuit
    public let date: String
    public let time: String
    public let qualifyingResults: [QualifyingResult]?
    public let pitStops: [PitStop]?
    public let laps: [LapElement]?


    private enum CodingKeys: String, CodingKey {
        case season
        case round
        case url
        case raceName
        case circuit = "Circuit"
        case date
        case time
        case qualifyingResults = "QualifyingResults"
        case pitStops = "PitStops"
        case laps = "Laps"
    }
}

public struct QualifyingResultsData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let raceTable: RaceTable

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case raceTable = "RaceTable"
    }
}

public struct QualifyingResult: Codable {
    public let number: String
    public let position: String
    public let driver: Driver
    public let constructor: Constructor
    public let q1: String
    public let q2: String?
    public let q3: String?

    private enum CodingKeys: String, CodingKey {
        case number
        case position
        case driver = "Driver"
        case constructor = "Constructor"
        case q1 = "Q1"
        case q2 = "Q2"
        case q3 = "Q3"
    }
}

public struct PitStopsData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let raceTable: RaceTable

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case raceTable = "RaceTable"
    }
}

public struct PitStop: Codable {
    public let driverID: String
    public let lap: String
    public let stop: String
    public let time: String
    public let duration: String

    private enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case lap
        case stop
        case time
        case duration
    }
}


public struct LapsData: Codable {
    public let series: String
    public let url: String
    public let limit: String
    public let offset: String
    public let total: String
    public let raceTable: RaceTable

    private enum CodingKeys: String, CodingKey {
        case series
        case url
        case limit
        case offset
        case total
        case raceTable = "RaceTable"
    }
}

public struct LapElement: Codable {
    public let number: String
    public let timings: [Timing]

    private enum CodingKeys: String, CodingKey {
        case number
        case timings = "Timings"
    }
}

public struct Timing: Codable {
    public let driverID: String
    public let position: String
    public let time: String

    private enum CodingKeys: String, CodingKey {
        case driverID = "driverId"
        case position
        case time
    }
}
