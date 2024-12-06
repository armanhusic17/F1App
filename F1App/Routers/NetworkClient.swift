//
//  NetworkClient.swift
//  F1App
//
//  Created by Arman Husic on 10/18/24.
//

import SwiftUI
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

    private func getCachedDataFromFileManager(for identifier: String, type: String) -> Data? {
        switch type {
            case "json":
                return FileManager.default.loadCachedJSONData(for: identifier)
            case "txt":
                return FileManager.default.loadCachedTextData(for: identifier)
            case "png":
                return FileManager.default.loadCachedImageData(for: identifier)
            default:
                print("Unsupported file type: \(type)")
                return nil
        }
    }
    
    private func saveCachedDataToFileManager(_ data: Data, for identifier: String, type: String) {
        switch type {
            case "json":
                FileManager.default.saveJSONDataToCache(data, for: identifier)
            case "txt":
                FileManager.default.saveTextDataToCache(data, for: identifier)
            case "png":
                FileManager.default.saveImageDataToCache(data, for: identifier)
            default:
                print("Unsupported file type: \(type)")
        }
    }
    
    @MainActor func worldDriversChampionshipStandings(seasonYear: String) async throws -> [DriverStanding] {
        let cacheIdentrifier = "cache_worldDriversChampionshipStandings_\(seasonYear)"
        
        if let cachedData = getCachedDataFromFileManager(for: cacheIdentrifier, type: "json") {
            do {
                let json = try JSONDecoder().decode(Root.self, from: cachedData)
                print("RETRIEVING DRIVER STANDINGS DATA FROM CACHE")
                return processDriverStandings(json, seasonYear: seasonYear)
            } catch {
                print("Error decoding driverStandings from cached data: \(error)")
            }
        }
        
        guard let url = URL(string: "\(baseURL)\(seasonYear)/driverStandings.json") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONDecoder().decode(Root.self, from: data)
        
        if seasonYear != "\(Calendar.current.component(.year, from: Date()))" {
            saveCachedDataToFileManager(data, for: cacheIdentrifier, type: "json")
            print("SUCCESSFULLY SAVING JSON DRIVERSTANDSINGS TO CACHE DATA")
        }
        
        return processDriverStandings(json, seasonYear: seasonYear)
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
        let cacheIdentifier = "driverImage_\(givenName)_\(familyName)"
        
        if let cachedData = FileManager.default.loadCachedTextData(for: cacheIdentifier),
           let imageUrl = String(data: cachedData, encoding: .utf8) {
            print("Using cached imageURL for driverImage_\(givenName)_\(familyName): \(imageUrl)")
            return imageUrl
        }
        
        let encodedGivenName = givenName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let encodedFamilyName = familyName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let driverPageTitle = "\(encodedGivenName)_\(encodedFamilyName)"

        let driverPageURLString = "https://en.wikipedia.org/w/api.php?action=query&titles=\(driverPageTitle)&prop=pageimages&format=json&pithumbsize=800"

        guard let url = URL(string: driverPageURLString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
        
        guard let pageID = wikipediaData.query.pages.keys.first,
              let page = wikipediaData.query.pages[pageID],
              let thumbnailURL = page.thumbnail?.source else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response for \(givenName) \(familyName)"])
        }
        // lets cache the url as text data from the filemanager
        if let imageData = thumbnailURL.data(using: .utf8) {
            FileManager.default.saveTextDataToCache(imageData, for: cacheIdentifier)
            print("SAVED ImageURL to FILEMANAGER")
        }

        print("Fetched and cached image URL for \(givenName) \(familyName): \(thumbnailURL)")

        return thumbnailURL
    }
    
    func getConstructorStandings(seasonYear: String) async throws -> [ConstructorStanding] {
        let cachedIdentifier = "constructionStandings_\(seasonYear)"
        
        if let cachedData = getCachedDataFromFileManager(for: cachedIdentifier, type: "json") {
            do {
                let root = try JSONDecoder().decode(Root.self, from: cachedData)
                print("Successfully gathered data from cache")
                return processConstructorStandings(root: root)
            } catch {
                print("Error decoding constructor standings from json cached data: \(error)")
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
            saveCachedDataToFileManager(data, for: cachedIdentifier, type: "json")
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
        let cacheIdentifier = "raceResults_\(round)_\(season)"
        
        if let cachedData = getCachedDataFromFileManager(for: cacheIdentifier, type: "json") {
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
            if season != "\(Calendar.current.component(.year, from: Date()))" {
                saveCachedDataToFileManager(data, for: cacheIdentifier, type: "json")
                print("SUCCESSFULLY saved race results for season: \(season), round: \(round)")
            }
        }

        return root
    }

    func fetchRaceSchedule(forYear year: String) async throws -> Root {
        let cacheIdentifier = "raceSchedule_\(year)"
        
        if let cachedData = getCachedDataFromFileManager(for: cacheIdentifier, type: "json") {
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
            if year != "\(Calendar.current.component(.year, from: Date()))" {
                let data = try JSONEncoder().encode(root)
                saveCachedDataToFileManager(data, for: cacheIdentifier, type: "json")
                print("Successfully saved race schedule to cache for year: \(year)")
            }
            return root
        } catch {
            print("Error fetching race scedule: \(error)")
            throw error
        }
    }
    
    func fetchConstructorImageFromWikipedia(constructorName: String) async throws -> Image {
        let cacheIdentifier = "constructor_\(constructorName)"
        
        // check if the data exists in cache
        if let cachedData = FileManager.default.loadCachedImageData(for: cacheIdentifier),
           let uiImage = UIImage(data: cachedData) {
            print("Using cached image for \(constructorName)")
            return Image(uiImage: uiImage)
        }
        
        // encode name for url and fetch the image url
        let encodedName = constructorName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlStr = "https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrsearch=\(encodedName)%20racing%20team&prop=pageimages&format=json&gsrlimit=6&redirects=1&pithumbsize=800"

        guard let url = URL(string: urlStr) else {
            print(URLError(.badURL))
            throw URLError(.badURL)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
            
            if let pageID = wikipediaData.query.pages.keys.first,
               let page = wikipediaData.query.pages[pageID],
               let thumbnailURLString = page.thumbnail?.source,
               let thumbnailURL = URL(string: thumbnailURLString) {
                
                // doanload the image data from the thumbnailURL
                let (imageData, _) = try await URLSession.shared.data(from: thumbnailURL)
                FileManager.default.saveImageDataToCache(imageData, for: cacheIdentifier)
                print("Fetched and cached image for constructor: \(constructorName)")
                
                // return as swiftui image
                if let uiImage = UIImage(data: imageData) {
                    return Image(uiImage: uiImage)
                } else {
                    return Image(uiImage: UIImage(systemName: "car.fill") ?? UIImage())
                }
            }
        } catch {
            print("Direct query failed: \(error)")
        }
        
        // Fallback to search if direct query didn't return an image
        return try await fetchConstructorImage(constructorName: constructorName)
    }
        
    func fetchConstructorImage(constructorName: String) async throws -> Image {
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
              let thumbnailURL = page.thumbnail?.source,
              let imageURL = URL(string: thumbnailURL) else {
            throw ImageFetchError.dataError(description: "No image found for \(constructorName)")
        }
        
        let (imageData, _) = try await URLSession.shared.data(from: imageURL)
        let cacheIdentifier = "constructorImage_\(constructorName)"
        FileManager.default.saveImageDataToCache(imageData, for: cacheIdentifier)
        
        if let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            throw ImageFetchError.dataError(description: "Image conversion failed for : \(constructorName)")
        }
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
