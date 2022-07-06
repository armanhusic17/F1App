//
//  RaceResults.swift
//  F1App
//
//  Created by Arman Husic on 7/5/22.
//

import Foundation

public struct RaceResults: Codable {
    public let data: RaceData
    
    private enum CodingKeys: String, CodingKey {
        case data = "MRData"
    }
}

public extension RaceResults {
    var currentRaces: [Race] { self.data.raceTable.races }
}


public struct RaceData: Codable {
        public let xmlns: String?
        public let series: String?
        public let url: String?
        public let limit: String?
        public let offset: String?
        public let total: String?
        public let raceTable: RaceTable

        private enum CodingKeys: String, CodingKey {
            case xmlns, series, url, limit, offset, total
            case raceTable = "RaceTable"
        }
    }
    
public struct RaceTable: Codable {
        public let season: String?
        public let position: String?
        public let races: [Race]

        private enum CodingKeys: String, CodingKey {
            case season
            case position
            case races = "Races"
        }
    }
    
public struct Race: Codable {
        public let season, round: String
        public let url: String
        public let raceName: String
        public let circuit: CircuitData
        public let date, time: String
        public let results: [Result]

        private enum CodingKeys: String, CodingKey {
            case season, round, url, raceName
            case circuit = "Circuit"
            case date, time
            case results = "Results"
        }
    }
    
public struct Result: Codable {
        public let number, position, positionText, points: String
        public let driver: [Driver]
        public let constructor: Constructor
        public let grid, laps, status: String
        public let time: ResultTime?
        public let fastestLap: FastestLap

        private enum CodingKeys: String, CodingKey {
            case number, position, positionText, points
            case driver = "Driver"
            case constructor = "Constructor"
            case grid, laps, status
            case time = "Time"
            case fastestLap = "FastestLap"
        }
    }
    
public struct FastestLap: Codable {
        public let rank, lap: String
        public let time: FastestLapTime
        public let averageSpeed: AverageSpeed

        private enum CodingKeys: String, CodingKey {
            case rank, lap
            case time = "Time"
            case averageSpeed = "AverageSpeed"
        }
    }

public struct AverageSpeed: Codable {
        public let units: Units
        public let speed: String
    

        public enum Units: String, Codable {
            case kph = "kph"
        }
    }

public struct FastestLapTime: Codable {
        public let time: String
    }

public struct ResultTime: Codable {
        public let millis, time: String
    }
    
    
    

