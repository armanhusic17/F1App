//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var isLoadingDrivers = false
    @Published var isLoadingConstructors = false
    @Published var driverStandings: [DriverStanding] = []
    @Published var raceResults: Root?
    @Published var races: [Race] = []
    @Published var raceWinner: [String] = []
    @Published var winningConstructor: [String] = []
    @Published var winningTime: [String] = []
    @Published var winnerFastestLap: [String] = []
    @Published var errorMessage: String?
    @Published var constructorStandings: [ConstructorStanding] = []
    @Published var constructorImages: [String] = []
    @Published var seasonYear: String = "\(Calendar.current.component(.year, from: Date()))" {
        didSet {
            Task {
                await self.reloadDataForNewSeason()
            }
        }
    }
    
    init(
        seasonYear: String
    ) {
        self.seasonYear = seasonYear
    }
    
    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2024
    }
    
    @MainActor private func reloadDataForNewSeason() async {
        driverStandings.removeAll()
        constructorStandings.removeAll()
        constructorImages.removeAll()
        winningConstructor.removeAll()
        winnerFastestLap.removeAll()
        winningTime.removeAll()
        raceWinner.removeAll()
        races.removeAll()

        await loadAllRacesForSeason(year: seasonYear)
        await loadDriverStandings(seasonYear: seasonYear)
        await getDriverImgs()
        await loadConstructorStandings(seasonYear: seasonYear)
        await getConstructorImages()
        await loadRaceResultsForYear(year: seasonYear)
    }
    
    @MainActor func loadDriverStandings(seasonYear: String) async {
        isLoadingDrivers = true
        do {
            let standings = try await F1ApiRoutes.worldDriversChampionshipStandings(seasonYear: self.seasonYear)
            driverStandings.append(contentsOf: standings)
            isLoadingDrivers = false
            // Update UI or state with standings
        } catch {
            // Handle errors such as display an error message
            isLoadingDrivers = false
        }
    }
    
    @MainActor func getDriverImgs() async {
        for index in driverStandings.indices {
            do {
                let driverImg = try await F1ApiRoutes.fetchDriverImgFromWikipedia(
                    givenName: self.driverStandings[index].givenName,
                    familyName: self.driverStandings[index].familyName)
                self.driverStandings[index].imageUrl = driverImg
            } catch {
                // Handle errors such as display an error message
                print("Drivers query failed to gather data...")
            }
        }
    }
    
    @MainActor func loadConstructorStandings(seasonYear: String) async {
        isLoadingConstructors = true
        do {
            let standings = try await F1ApiRoutes.getConstructorStandings(seasonYear: self.seasonYear)
            self.constructorStandings.append(contentsOf: standings)
            isLoadingConstructors = false
        } catch {
            print("Constructors query failed to gather data...")
            isLoadingConstructors = false
        }
    }
    
    @MainActor func getConstructorImages() async {
        for index in constructorStandings.indices {
            do {
                let constructorImg = try await F1ApiRoutes.fetchConstructorImageFromWikipedia(constructorName: self.constructorStandings[safe: index]?.constructor?.name ?? "Unable to get constructor name")
                constructorImages.append(constructorImg)
                print(self.constructorStandings[safe: index]?.constructor?.name ?? "Unable to get constructor name")
            } catch {
                // Handle errors such as display an error message
                constructorImages.append("bad_url")
                print("Constructors wikipedia fetch failed to gather data...\(error)")
            }
        }
    }
    
    @MainActor func loadAllRacesForSeason(year: String) async {
        isLoading = true
        Task {
            do {
                let raceResults = try await F1ApiRoutes().fetchRaceSchedule(forYear: year)
                self.races = raceResults?.mrData?.raceTable?.races ?? []
                print("NUMBER OF RACES \(races.count)")
                isLoading = false
            } catch {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            }
        }
    }
    
    @MainActor func loadRaceResultsForYear(year: String) async {
        isLoading = true
        for index in Range(1...races.count + 1) {
            do {
                let raceResultsData = try await F1ApiRoutes().fetchRaceResults(
                    forYear: year,
                    round: "\(index)"
                )
                raceWinner.append(
                    "\(raceResultsData?.mrData?.raceTable?.races?.first?.results?.first?.driver?.givenName ?? "") \(raceResultsData?.mrData?.raceTable?.races?.first?.results?.first?.driver?.familyName ?? "")"
                )
                winningConstructor.append(raceResultsData?.mrData?.raceTable?.races?.first?.results?.first?.constructor?.name ?? "")
                winningTime.append(raceResultsData?.mrData?.raceTable?.races?.first?.results?.first?.time?.time ?? "")
                winnerFastestLap.append(raceResultsData?.mrData?.raceTable?.races?.first?.results?.first?.fastestLap?.time?.time ?? "")

                isLoading = false
            } catch {
                print("failed to fetch data \(error.localizedDescription)")
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
