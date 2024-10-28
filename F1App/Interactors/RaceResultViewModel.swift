//
//  RaceResultViewModel.swift
//  F1App
//
//  Created by Arman Husic on 10/15/24.
//

import SwiftUI

@MainActor
class RaceResultViewModel: ObservableObject {
    enum Constants {
        static let titleImg: String = "flag.pattern.checkered.circle"
        static let rowIcon: String = "person.circle"
        static let fallbackTitle: String = "Grand Prix Results"
        static let gridPositionIcon: String = "rectangle.grid.2x2"
        static let fastestLapIcon: String = "gauge.open.with.lines.needle.67percent.and.arrowtriangle.and.car"
        static let pointsIcon: String = "bolt.car.circle"
    }

    init() { /* No Op*/ }
    
    func resultsPositionAndStatus(resultStatus: Result, index: Int) -> String {
        let resultStatusString = "\(resultStatus.status ?? ""): P\(resultStatus.position ?? "\(index + 1)")"
        return resultStatusString
    }
    
    func resultsQualified(result: Result) -> String {
        return "Qualified: P\(result.grid ?? "")"
    }
    
    func resultsPoints(result: Result) -> String {
        return "Points: \(result.points ?? "")"
    }
    
    func resultsFastestLap(fastestLapTime: String, fastestLap: String) -> String {
        return "Fastest Lap: \(fastestLapTime), Lap: \(fastestLap)"
    }
    
    func raceDate(race: Race) -> String {
        return "\(race.date ?? ""), \(race.time ?? "")"
    }
    
    func constructorName(result: Result) -> String {
        return "\(result.constructor?.name ?? "")"
    }
    
    func driverName(result: Result) -> String {
        return "\(result.driver?.givenName ?? "") \(result.driver?.familyName ?? "")"
    }
    
    func driverNumber(result: Result) -> String? {
        guard let driverNumber = result.driver?.permanentNumber else { return nil}
        return "#\(driverNumber)"
    }

    var customGrandient: LinearGradient {
        LinearGradient(
            colors: [
                .black.opacity(0.9),
                .red.opacity(0.5),
                .black.opacity(0.75)
            ],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }

    func matchDriver(viewModel: HomeViewModel, result: Result) -> DriverStanding? {
        let driverStanding = viewModel.driverStandings.first { standing in
            standing.givenName == result.driver?.givenName &&
            standing.familyName == result.driver?.familyName
        }
        return driverStanding
    }
}
