//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    private let networkClient: NetworkClient
    @Published var raceResultViewModel: RaceResultViewModel? = nil
    @Published var isLoadingGrandPrix = false
    @Published var isLoadingDrivers = false
    @Published var isLoadingConstructors = false
    @Published var isLoadingRaceResults = false
    @Published var driverStandings: [DriverStanding] = []
    @Published var raceResults: Root?
    @Published var raceResults2: [Result] = []
    @Published var winner: String = ""
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
    
    enum Constant: String {
        case homescreenTitle = "Grid Pulse"
        case wdcLabel = "World Drivers' Championship Standings"
        case grandPrixLabel = "Grand Prix Results"
    }
    
    init(
        networkClient: NetworkClient,
        seasonYear: String
    ) {
        self.networkClient = networkClient
        self.seasonYear = seasonYear
        Task {
            await initializeData()
        }
    }
    
    private func initializeData() async {
        self.raceResultViewModel = RaceResultViewModel()
    }
    
    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2024
    }
    
    private func clearData() {
        driverStandings.removeAll()
        constructorStandings.removeAll()
        constructorImages.removeAll()
        winningConstructor.removeAll()
        winnerFastestLap.removeAll()
        winningTime.removeAll()
        raceWinner.removeAll()
        races.removeAll()
    }
    
    func clearRaceResults() {
        raceResults2.removeAll()
    }
    
    @MainActor private func reloadDataForNewSeason() async {
        clearData()
        async let loadRacesTask: () = loadAllRacesForSeason(year: seasonYear)
        async let loadDriverStandingsTask: () = loadDriverStandings(seasonYear: seasonYear)
        async let loadConstructorStandingsTask: () = loadConstructorStandings(seasonYear: seasonYear)

        _ = await (loadRacesTask, loadDriverStandingsTask, loadConstructorStandingsTask)

        async let getDriverImgsTask: () = getDriverImgs()

        _ = await getDriverImgsTask

        async let loadQuickLookResults: () = loadRaceResultsForYear(year: seasonYear)
        await loadQuickLookResults
    }
    
    @MainActor func loadDriverStandings(seasonYear: String) async {
        isLoadingDrivers = true
        do {
            let standings = try await networkClient.worldDriversChampionshipStandings(seasonYear: self.seasonYear)
            driverStandings.removeAll()
            driverStandings.append(contentsOf: standings.unique(by: {$0.familyName}))
            // Update UI or state with standings
        } catch {
            // Handle errors such as display an error message
            print("Error gathering driver standings... \(error.localizedDescription)")
        }
        isLoadingDrivers = false
    }
    
    @MainActor func getDriverImgs() async {
        let nc = self.networkClient
        for index in driverStandings.indices {
            Task { [weak self] in
                guard let self else { return }
                let driverImg = try await nc.fetchDriverImgFromWikipedia(
                    givenName: self.driverStandings[safe: index]?.givenName ?? "⏳",
                    familyName: self.driverStandings[safe: index]?.familyName ?? "⏳")
                self.driverStandings[index].imageUrl = driverImg
            }
        }
    }
    
    @MainActor func loadConstructorStandings(seasonYear: String) async {
        let nc = self.networkClient
        isLoadingConstructors = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let standings = try await nc.getConstructorStandings(seasonYear: self.seasonYear)
                constructorStandings.removeAll()
                self.constructorStandings.append(contentsOf: standings.unique(by: { $0.constructor?.name ?? ""}))
                await self.getConstructorImages()
            } catch {
                print("Constructors query failed to gather data...")
            }
            isLoadingConstructors = false
        }
    }
    
    @MainActor func getConstructorImages() async {
        let nc = self.networkClient
        isLoadingConstructors = true
        let constructorLoop = constructorStandings.indices
        Task { [weak self] in
            for index in constructorLoop {
                do {
                    let constructorImg = try await nc.fetchConstructorImageFromWikipedia(constructorName: self?.constructorStandings[safe: index]?.constructor?.name ?? "Unable to get constructor name")
                    self?.constructorImages.append(constructorImg)
                    print(self?.constructorStandings[safe: index]?.constructor?.name ?? "Unable to get constructor name")
                } catch {
                    // Handle errors such as display an error message
                    self?.constructorImages.append("bad_url")
                    print("Constructors wikipedia fetch failed to gather data...\(error)")
                }
            }
        }
    }
    
    @MainActor func loadAllRacesForSeason(year: String) async {
        let nc = self.networkClient
        isLoadingGrandPrix = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let raceResults = try await nc.fetchRaceSchedule(forYear: year)
                self.races = raceResults.mrData?.raceTable?.races ?? []
                print("NUMBER OF RACES \(races.count)")
            } catch {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
            }
            isLoadingGrandPrix = false
        }
    }
    
    @MainActor func loadRaceResultsForYear(year: String) async {
        let nc = self.networkClient
        isLoadingRaceResults = true
        Task { [weak self] in
            guard let self else { return }

            for index in Range(1...races.count + 1) {
                do {
                    let raceResultsData = try await nc.fetchRaceResults(
                        season: year,
                        round: "\(index)"
                    )
                    raceWinner.append(
                        "\(raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.driver?.givenName ?? "") \(raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.driver?.familyName ?? "")"
                    )
                    winningConstructor.append(
                        raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.constructor?.name ?? ""
                    )
                    winningTime.append(
                        raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.time?.time ?? ""
                    )
                    winnerFastestLap.append(
                        raceResultsData.mrData?.raceTable?.races?.first?.results?.first?.fastestLap?.time?.time ?? ""
                    )
                } catch {
                    print("failed to fetch data \(error.localizedDescription)")
                }
            }
        }

        isLoadingRaceResults = false
    }
    
    @MainActor func fetchRaceResults(season: String, round: String) async {
        let nc = self.networkClient
        Task { [weak self] in
            guard let self else { return }
            do {
                let results = try await nc.fetchRaceResults(
                    season: season,
                    round: round
                )

                if let race = results.mrData?.raceTable?.races?.first {
                    await MainActor.run {
                        self.raceResults2 = race.results ?? []

                        if let winner = race.results?.first {
                            self.winner = "\(winner.driver?.givenName ?? "") \(winner.driver?.familyName ?? "")"
                        }
                    }
                }
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
