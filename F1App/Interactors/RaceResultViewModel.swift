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
