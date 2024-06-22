//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var seasonYear: String = "2024"
    @Published var drivers: [String?] = []
    @Published var driverStandings: [DriverStanding] = []
    @Published var gridCellItems: [[String]] = []
    @Published var driverImages: [String] = []
    @Published var raceResults: Root?
    @Published var errorMessage: String?
    
    init(
        seasonYear: String
    ) {
        self.seasonYear = returnYear().description
    }
    
    var uniqueTeams: [DriverStanding] {
        return driverStandings.unique(by: { $0.teamNames })
    }

    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2024
    }
    
    @MainActor
    func loadDriverStandings(seasonYear: String) async {
        do {
            let standings = try await F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: self.seasonYear)
            driverStandings.append(contentsOf: standings)
            // Update UI or state with standings
        } catch {
            // Handle errors such as display an error message
        }
    }
    
    @MainActor
    func getDriverImgs() async {
        do {
            let driverImgs = try await F1ApiRoutes.fetchDriverInfoFromWikipedia(givenName: "Lewis", familyName: "Hamilton")
            driverImages.append(driverImgs)
            // Update UI or state with standings
        } catch {
            // Handle errors such as display an error message
        }
    }
    
    @MainActor
    func loadRaceResults(year: String, round: String) {
        Task {
            do {
                self.raceResults = try await F1ApiRoutes().fetchRaceResults(forYear: year, round: round)
            } catch {
                self.errorMessage = "Failed to fetch data: \(error)"
            }
        }
    }
}

extension Array {
    func unique<T: Hashable>(by key: (Element) -> T) -> [Element] {
        var seenKeys = Set<T>()
        return filter { element in
            let key = key(element)
            return seenKeys.insert(key).inserted
        }
    }
}
