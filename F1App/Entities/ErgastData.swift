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

struct Root: Codable {
    let mrData: MRData?

    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRData: Codable {
    let raceTable: RaceTable?
    let standingsTable: StandingsTable?
    let series: String?
    let url: String?
    let limit: String?
    let offset: String?
    let total: String?
    
    private enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
        case standingsTable = "StandingsTable"
        case series
        case url
        case limit
        case offset
        case total
    }
}

struct Time: Codable {
    let millis: String?
    let time: String?
    
    private enum CodingKeys: String, CodingKey {
        case millis, time
    }
}

struct RaceResults: Codable {
    let mrData: MRData?
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct StandingsTable: Codable {
    let season: String?
    let standingsLists: [StandingsList]?

    enum CodingKeys: String, CodingKey {
        case season
        case standingsLists = "StandingsLists"
    }
}

struct StandingsList: Codable {
    let season: String?
    let round: String?
    let constructorStandings: [ConstructorStanding]?
    let driverStandings: [DriverStanding]?

    enum CodingKeys: String, CodingKey {
        case season
        case round
        case constructorStandings = "ConstructorStandings"
        case driverStandings = "DriverStandings"
    }
}

struct ConstructorStanding: Codable, Hashable {
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

struct Constructor: Codable, Hashable {
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

struct RaceTable: Codable {
    let races: [Race]?
    let season: String?
    let round: String?
    
    private enum CodingKeys: String, CodingKey {
        case races = "Races"
        case season = "season"
        case round = "round"
    }
}

struct Race: Codable {
    let raceName: String?
    let circuit: Circuit?
    let date: String?
    let time: String?
    let results: [Result]?
    let laps: [Lap]?

    private enum CodingKeys: String, CodingKey {
        case raceName = "raceName"
        case circuit = "Circuit"
        case date = "date"
        case time = "time"
        case results = "Results"
        case laps = "Laps"
    }
}

struct Circuit: Codable {
    let circuitName: String?
    let location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case circuitName = "circuitName"
        case location = "Location"
    }
}

struct Location: Codable {
    let locality: String?
    let country: String?
    let lat: String?
    let long: String?
    
    private enum CodingKeys: String, CodingKey {
        case locality = "locality"
        case country = "country"
        case lat = "lat"
        case long = "long"
    }
}

struct Result: Codable {
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


struct Driver: Codable {
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

struct FastestLap: Codable {
    let lap: String?
    let time: LapTime?
    let averageSpeed: AverageSpeed?

    enum CodingKeys: String, CodingKey {
        case lap = "lap"
        case time = "Time"
        case averageSpeed = "AverageSpeed"
    }
}

struct LapTime: Codable {
    let time: String?

    enum CodingKeys: String, CodingKey {
        case time = "time"
    }
}

struct AverageSpeed: Codable {
    let units: String?
    let speed: String?

    enum CodingKeys: String, CodingKey {
        case units = "units"
        case speed = "speed"
    }
}

struct Lap: Codable {
    let number: String?
    let timings: [Timing]?

    enum CodingKeys: String, CodingKey {
        case number
        case timings = "Timings"
    }
}

struct Timing: Codable {
    let driverId: String?
    let position: String?
    let time: String?
}

struct DriverStanding: Codable, Hashable {
    var givenName: String
    var familyName: String
    var position: String
    var points: String
    var teamNames: String
    var imageUrl: String
}

struct DriverStandingResponse: Codable {
    let position: String?
    let positionText: String?
    let points: String?
    let wins: String?
    let driver: Driver?
    let constructor: [Constructor?]
    
    enum CodingKeys: String, CodingKey {
        case position
        case positionText
        case points
        case wins
        case driver = "Driver"
        case constructor = "Constructors"
    }
}

struct SeasonStanding: Codable, Hashable {
    var seasonYear: String
    var drivers: [DriverStanding]
}
