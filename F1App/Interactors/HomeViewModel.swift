//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var seasonYear: String = "\(Calendar.current.component(.year, from: Date()))"

    {
        didSet {
            Task {
                loadAllRacesForSeason(year: seasonYear)
                await self.reloadDataForNewSeason()
            }
        }
    }
    @Published var driverStandings: [DriverStanding] = []
    @Published var raceResults: Root?
    @Published var races: [Race] = []
    @Published var errorMessage: String?
    @Published var constructorStandings: [ConstructorStanding] = []
    @Published var constructorImages: [String] = []

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
    
    @MainActor
    private func reloadDataForNewSeason() async {
        driverStandings.removeAll()
        constructorStandings.removeAll()
        constructorImages.removeAll()
        
        await loadDriverStandings(seasonYear: seasonYear)
        await getDriverImgs()
        await loadConstructorStandings(seasonYear: seasonYear)
        await getConstructorImages()
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
    
    @MainActor
    func loadConstructorStandings(seasonYear: String) async {
        do {
            let standings = try await F1ApiRoutes.getConstructorStandings(seasonYear: self.seasonYear)
            self.constructorStandings.append(contentsOf: standings)
        } catch {
            print("Constructors query failed to gather data...")
        }
    }
    
    @MainActor
    func getConstructorImages() async {
        for index in constructorStandings.indices {
            do {
                let constructorImg = try await F1ApiRoutes.fetchConstructorImageFromWikipedia(constructorName: self.constructorStandings[index].constructor?.name ?? "Unable to get constructor name")
                constructorImages.append(constructorImg)
                print(self.constructorStandings[index].constructor?.name ?? "Unable to get constructor name")
            } catch {
                // Handle errors such as display an error message
                constructorImages.append("bad_url")
                print("Constructors wikipedia fetch failed to gather data...\(error)")
            }
        }
    }
    
    @MainActor
    func loadAllRacesForSeason(year: String) {
        Task {
            do {
                let raceResults = try await F1ApiRoutes().fetchRaceResults(forYear: year)
                DispatchQueue.main.async {
                    self.races = raceResults?.mrData?.raceTable?.races ?? []
                }
            } catch {
                self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
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
