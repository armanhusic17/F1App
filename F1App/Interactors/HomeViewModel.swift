//
//  HomeViewModel.swift
//  F1App
//
//  Created by Arman Husic on 4/27/24.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var seasonYear: String = "2024" {
        didSet {
            Task {
                await self.reloadDataForNewSeason()
            }
        }
    }
    @Published var driverStandings: [DriverStanding] = []
    @Published var gridCellItems: [[String]] = []
    @Published var driverImages: [String] = []
    @Published var raceResults: Root?
    @Published var errorMessage: String?
    
    @Published var constructorStandings: [ConstructorStanding] = []
    @Published var constructorImages: [String] = []
    
    init(
        seasonYear: String
    ) {
        self.seasonYear = seasonYear
    }
    
    var uniqueTeams: [DriverStanding] {
        return driverStandings.unique(by: { $0.teamNames })
    }

    private func returnYear() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: Date())) ?? 2020
    }
    
    @MainActor
    private func reloadDataForNewSeason() async {
        driverStandings.removeAll()
        driverImages.removeAll()
        constructorStandings.removeAll()
        constructorImages.removeAll()
        await loadDriverStandings(seasonYear: seasonYear)
        await getDriverImgs()
        await loadConstructorStandings(seasonYear: seasonYear)
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
                let driverImg = try await F1ApiRoutes.fetchDriverInfoFromWikipedia(
                    givenName: self.driverStandings[index].givenName,
                    familyName: self.driverStandings[index].familyName)
                self.driverStandings[index].imageUrl = driverImg
                driverImages.append(driverImg)
                // Update UI or state with standings
            } catch {
                // Handle errors such as display an error message
            }
        }
    }
    
    @MainActor
    func loadConstructorStandings(seasonYear: String) async {
        do {
            let standings = try await F1ApiRoutes.getConstructorStandings(seasonYear: self.seasonYear)
            self.constructorStandings.append(contentsOf: standings)
            
        } catch {
            
        }
    }
    
    @MainActor
    func getConstructorImages() async {
        for index in constructorStandings.indices {
            do {
                
            } catch {
                // Handle errors such as display an error message
            }
        }
    }
    
    @MainActor
    // In your ViewModel or appropriate data handler
    func fetchConstructorImages(constructors: [ConstructorStanding]) async {
        for constructor in constructors {
            guard let name = constructor.constructor?.name else { continue }
            do {
                let imageUrl = try await HomeViewModel.fetchConstructorImageFromWikipedia(constructorName: name)
                DispatchQueue.main.async {
                    // Assume you have a way to link images back to the constructors
                    self.constructorImages.append(imageUrl)
                }
            } catch {
                print("Failed to fetch image for \(name): \(error)")
            }
        }
    }

    static func fetchConstructorImageFromWikipedia(constructorName: String) async throws -> String {
        let encodedName = constructorName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlStr = "https://en.wikipedia.org/w/api.php?action=query&titles=\(encodedName)&prop=pageimages&format=json&pithumbsize=250"
        guard let url = URL(string: urlStr) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
        
        guard let pageID = wikipediaData.query.pages.keys.first,
              let page = wikipediaData.query.pages[pageID],
              let thumbnailURL = page.thumbnail?.source else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response for \(constructorName)"])
        }

        return thumbnailURL
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
