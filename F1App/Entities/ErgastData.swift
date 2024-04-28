//
//  ErgastData.swift
//  F1App
//
//  Created by Arman Husic on 11/19/23.
//

import Foundation

/**
 https://ergast.com/api/f1/2008/results/1
 working on adding results that show up for drivers or teams or as a standalone not sure yet
 */

struct Root: Decodable {
    let mrData: MRData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRData: Decodable {
    let raceTable: RaceTable?
    let standingsTable: StandingsTable?
    
    private enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
        case standingsTable = "StandingsTable"

    }
}

struct Time: Decodable {
    let millis: String?
    let time: String?
    
    private enum CodingKeys: String, CodingKey {
        case millis, time
    }
}

struct RaceResults: Decodable {
    let mrData: MRData?
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}



struct StandingsTable: Decodable {
    let season: String?
    let standingsLists: [StandingsList]?

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

struct StandingsList: Decodable {
    let season: String?
    let round: String?
    let constructorStandings: [ConstructorStanding]?

    enum CodingKeys: String, CodingKey {
        case season
        case round
        case constructorStandings = "ConstructorStandings"
    }
}

struct ConstructorStanding: Decodable {
    let position: String?
    let positionText: String?
    let points: String?
    let wins: String?
    let constructor: Constructor?

    enum CodingKeys: String, CodingKey {
        case position
        case positionText
        case points
        case wins
        case constructor = "Constructor"
    }
}

struct Constructor: Decodable {
    let constructorId: String?
    let url: String?
    let name: String?
    let nationality: String?

    enum CodingKeys: String, CodingKey {
        case constructorId = "constructorId"
        case url = "url"
        case name = "name"
        case nationality = "nationality"
    }
}

struct RaceTable: Decodable {
    let races: [Race]?
    let season: String?
    let round: String?
    
    private enum CodingKeys: String, CodingKey {
        case races = "Races"
        case season = "season"
        case round = "round"
    }
}

struct Race: Decodable {
    let raceName: String?
    let circuit: Circuit?
    let date: String?
    let time: String?
    let results: [Result]?
    let laps: [Lap]?  // Add this line to include Laps

    
    private enum CodingKeys: String, CodingKey {
        case raceName = "raceName"
        case circuit = "Circuit"
        case date = "date"
        case time = "time"
        case results = "Results"
        case laps = "Laps"
    }
}

struct Circuit: Decodable {
    let circuitName: String?
    let location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case circuitName = "circuitName"
        case location = "Location"
    }
}

struct Location: Decodable {
    let locality: String?
    let country: String?
    
    private enum CodingKeys: String, CodingKey {
        case locality = "locality"
        case country = "country"
    }
}

struct Result: Decodable {
    let number: String?
    let position: String?
    let positionText: String?
    let points: String?
    let driver: Driver?
    let constructor: Constructor?
    let grid: String?
    let laps: String?
    let status: String?
    let time: Time?
    let fastestLap: FastestLap?
    
    private enum CodingKeys: String, CodingKey {
        case number = "number"
        case position = "position"
        case positionText = "positionText"
        case points = "points"
        case driver = "Driver"
        case constructor = "Constructor"
        case grid = "grid"
        case laps = "laps"
        case status = "status"
        case time = "Time"
        case fastestLap = "FastestLap"
    }
}


struct Driver: Decodable {
    let driverId: String?
    let permanentNumber: String?
    let code: String?
    let url: String?
    let givenName: String?
    let familyName: String?
    let dateOfBirth: String?
    let nationality: String?
    
    private enum CodingKeys: String, CodingKey {
        case driverId = "driverId"
        case permanentNumber = "permanentNumber"
        case code = "code"
        case url = "url"
        case givenName = "givenName"
        case familyName = "familyName"
        case dateOfBirth = "dateOfBirth"
        case nationality = "nationality"
    }
}

struct FastestLap: Decodable {
    let lap: String?
    let time: LapTime?
    let averageSpeed: AverageSpeed?

    enum CodingKeys: String, CodingKey {
        case lap = "lap"
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

struct LapTime: Decodable {
    let time: String?

    enum CodingKeys: String, CodingKey {
        case time = "time"
    }
}

struct AverageSpeed: Decodable {
    let units: String?
    let speed: String?

    enum CodingKeys: String, CodingKey {
        case units = "units"
        case speed = "speed"
    }
}

// New struct for Lap
struct Lap: Decodable {
    let number: String?
    let timings: [Timing]?

    enum CodingKeys: String, CodingKey {
        case number
        case timings = "Timings"
    }
}

// New struct for Timing
struct Timing: Decodable {
    let driverId: String?
    let position: String?
    let time: String?
}
