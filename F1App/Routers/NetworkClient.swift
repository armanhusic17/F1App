//
//  NetworkClient.swift
//  F1App
//
//  Created by Arman Husic on 10/18/24.
//

import Foundation
import Get

class NetworkClient {
    private let baseURL: URL
    private let apiClient: APIClient

    enum Endpoints: String {
        case baseURL = "https://ergast.com/api/f1/"
    }

    init() {
        self.baseURL = URL(string: Endpoints.baseURL.rawValue)!
        self.apiClient = APIClient(baseURL: baseURL)
    }

    private func getCachedData(for seasonYear: String, queryKey: String) -> Data? {
        let key = "cache_\(queryKey)_\(seasonYear)"
        if let cachedData = UserDefaults.standard.data(forKey: key) {
            return cachedData
        } else {
            // Log an error or handle the absence of data gracefully
            print("No cached data available for key: \(key)")
            return nil
        }
    }
    
    private func saveCachedData(_ data: Data, for seasonYear: String, queryKey: String) {
        let key = "cache_\(queryKey)_\(seasonYear)"
        UserDefaults.standard.set(data, forKey: key)
    }
    
    @MainActor func worldDriversChampionshipStandings(seasonYear: String) async throws -> [DriverStanding] {
        if let cachedData = getCachedData(for: seasonYear, queryKey: "worldDriversChampionshipStandings") {
            do {
                let json = try JSONDecoder().decode(Root.self, from: cachedData)
                return processDriverStandings(json, seasonYear: seasonYear)
            } catch {
                print("Error decoding the cached data \(error)")
                UserDefaults.standard.removeObject(forKey: "cache_worldDriversChampionshipStandings_\(seasonYear)")
            }
        } else {
            // if no cache was found lets make a network requerst
            guard let url = URL(string: "\(baseURL)\(seasonYear)/driverStandings.json") else {
                throw URLError(.badURL)
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let json = try JSONDecoder().decode(Root.self, from: data)
                
                if seasonYear != "2024" {
                    saveCachedData(data, for: seasonYear, queryKey: "cache_worldDriversChampionshipStandings_")
                }
                
                return processDriverStandings(json, seasonYear: seasonYear)
            } catch {
                print("Error -- \(error)")
            }
        }
        return [
            DriverStanding(
                givenName: "",
                familyName: "",
                position: "",
                points: "",
                teamNames: "",
                imageUrl: "",
                driver: nil,
                constructor: [nil]
            )
        ]
    }

    func processDriverStandings(_ json: Root, seasonYear: String) -> [DriverStanding] {
        guard let standingsTable = json.mrData?.standingsTable,
              let standingsLists = standingsTable.standingsLists else {
            return []
        }

        var results: [DriverStanding] = []

        for standingsList in standingsLists {
            let driverStandings = standingsList.driverStandings ?? []
            for driverStanding in driverStandings {

                let standing = DriverStanding(
                    givenName: driverStanding.driver?.givenName,
                    familyName: driverStanding.driver?.familyName,
                    position: driverStanding.position,
                    positionText: driverStanding.positionText,
                    points: driverStanding.points,
                    teamNames: driverStanding.teamNames,
                    imageUrl: driverStanding.imageUrl,
                    wins: driverStanding.wins,
                    driver: driverStanding.driver,
                    constructor: driverStanding.constructor
                )
                results.append(standing)
            }
        }
        print("RESULTS COUNT - \(results.count)")
        return results
    }

    
    func fetchDriverImgFromWikipedia(givenName: String, familyName: String) async throws -> String {
        let encodedGivenName = givenName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let encodedFamilyName = familyName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let driverPageTitle = "\(encodedGivenName)_\(encodedFamilyName)"
        let cacheKey = "cache_driverImage_\(driverPageTitle)"
        // Check if image URL is cached
        if let cachedURL = UserDefaults.standard.string(forKey: cacheKey) {
            print("Using cached image URL for \(givenName) \(familyName): \(cachedURL)")
            return cachedURL
        }
        // Construct the URL for the Wikipedia API request
        let driverPageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(driverPageTitle)&prop=pageimages&format=json&pithumbsize=800"
        guard let url = URL(string: driverPageURLString) else {
            throw URLError(.badURL)
        }
        // Perform the network request
        let (data, _) = try await URLSession.shared.data(from: url)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
        // Extract the thumbnail URL from the response
        guard let pageID = wikipediaData.query.pages.keys.first,
              let page = wikipediaData.query.pages[pageID],
              let thumbnailURL = page.thumbnail?.source else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response for \(givenName) \(familyName)"])
        }
        // Cache the thumbnail URL
        UserDefaults.standard.set(thumbnailURL, forKey: cacheKey)
        print("Fetched and cached image URL for \(givenName) \(familyName): \(thumbnailURL)")

        return thumbnailURL
    }
    
    func getConstructorStandings(seasonYear: String) async throws -> [ConstructorStanding] {
        // Check the cache first
        if let cachedData = getCachedData(for: seasonYear, queryKey: "constructorStandings") {
            do {
                let root = try JSONDecoder().decode(Root.self, from: cachedData)
                print("Successfully gathered data from cache")
                return processConstructorStandings(root: root)
            } catch {
                print("Error decoding cached data: \(error)")
                // Continue to fetch fresh data if cache is corrupted
            }
        }

        // Proceed with network call
        let urlString = "\(baseURL)\(seasonYear)/constructorStandings.json?limit=100"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        if seasonYear != "\(Calendar.current.component(.year, from: Date()))" {
            saveCachedData(data, for: seasonYear, queryKey: "cache_constructorStandings_\(seasonYear)")
        }

        return processConstructorStandings(root: root)
    }

    func processConstructorStandings(root: Root) -> [ConstructorStanding] {
        guard let standingsList = root.mrData?.standingsTable?.standingsLists?.first else {
            print("Standings table not found")
            return []
        }
        
        return standingsList.constructorStandings ?? []
    }
    
    func fetchRaceResults(season: String, round: String) async throws -> Root {
        if let cachedData = getCachedData(for: season, queryKey: "raceResults_\(round)_\(season)") {
            do {
                let cachedRoot = try JSONDecoder().decode(Root.self, from: cachedData)
                print("Returnng cached race results for season: \(season), round: \(round)")
                return cachedRoot
            } catch {
                print("Error decoding cached data: \(error)")
                throw error
            }
        }

        let request = Request<Root>(path: "\(season)/\(round)/results.json", method: .get)
        let root = try await apiClient.send(request).value
        
        if let data = try? JSONEncoder().encode(root) {
            if season != "2024" {
                saveCachedData(data, for: season, queryKey: "raceResults_\(round)_\(season)")
            }
        }

        return root
    }

    func fetchRaceSchedule(forYear year: String) async throws -> Root {
        let cacheKey = "raceSchedule_\(year)"
        
        if let cachedData = getCachedData(for: year, queryKey: cacheKey) {
            do {
                let cachedRoot = try JSONDecoder().decode(Root.self, from: cachedData)
                print("Returnng cached race schedule for year: \(year)")
                return cachedRoot
            } catch {
                print("Error decoding cached data: \(error)")
            }
        }

        let request = Request<Root>(path: "\(year).json", method: .get)
        do {
            let root = try await apiClient.send(request).value
            if year != "2024" {
                let data = try JSONEncoder().encode(root)
                saveCachedData(data, for: year, queryKey: cacheKey)
            }
            return root
        } catch {
            print("Error fetching race scedule: \(error)")
            throw error
        }
    }
    
    func fetchConstructorImageFromWikipedia(constructorName: String) async throws -> String {
        let encodedName = constructorName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlStr = "https://en.wikipedia.org/w/api.php?action=query&titles=\(encodedName)&prop=pageimages&redirects=1&format=json&pithumbsize=800"

        guard let url = URL(string: urlStr) else {
            print(URLError(.badURL))
            return "bad_url"
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
            
            if let pageID = wikipediaData.query.pages.keys.first,
               let page = wikipediaData.query.pages[pageID],
               let thumbnailURL = page.thumbnail?.source {
                print(thumbnailURL)
                return thumbnailURL
            }
        } catch {
            print("Direct query failed: \(error)")
        }
        
        // Fallback to search if direct query didn't return an image
        return try await fetchConstructorImage(constructorName: constructorName)
    }
        
    func fetchConstructorImage(constructorName: String) async throws -> String {
        let query = constructorName.addingPercentEncodingForWikipedia()
        let searchURLStr = "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=\(query)&format=json"

        guard let searchURL = URL(string: searchURLStr) else {
            throw ImageFetchError.invalidURL
        }

        let (searchData, _) = try await URLSession.shared.data(from: searchURL)
        let searchResults = try JSONDecoder().decode(WikipediaSearchData.self, from: searchData)

        guard let firstResult = searchResults.query.search.first else {
            throw ImageFetchError.dataError(description: "No search results found for \(constructorName)")
        }

        let pageID = firstResult.pageid
        let pageURLStr = "https://en.wikipedia.org/w/api.php?action=query&pageids=\(pageID)&prop=pageimages&format=json&pithumbsize=800"

        guard let pageURL = URL(string: pageURLStr) else {
            throw ImageFetchError.invalidURL
        }

        let (pageData, _) = try await URLSession.shared.data(from: pageURL)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: pageData)
        
        guard let page = wikipediaData.query.pages["\(pageID)"],
              let thumbnailURL = page.thumbnail?.source else {
            throw ImageFetchError.dataError(description: "No image found for \(constructorName)")
        }
        
        print(thumbnailURL)
        return thumbnailURL
    }
}

enum ImageFetchError: Error {
    case invalidURL
    case dataError(description: String)
}

extension String {
    func addingPercentEncodingForWikipedia() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
