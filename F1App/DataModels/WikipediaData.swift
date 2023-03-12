//
//  WikipediaData.swift
//  F1App
//
//  Created by Arman Husic on 3/11/23.
//

import Formula1API
import SwiftyJSON
import Foundation

struct WikipediaData: Decodable {
    let query: WikipediaQuery
}

struct WikipediaQuery: Decodable {
    let pages: [String: WikipediaPage]
}

struct WikipediaPage: Decodable {
    let thumbnail: WikipediaThumbnail?
}

struct WikipediaThumbnail: Decodable {
    let source: String
}

extension F1ApiRoutes {
    static func allConstructors(seasonYear: String, completion: @escaping () -> Void) {
        let url = "https://ergast.com/api/f1/\(seasonYear)/constructors.json"
        guard let unwrappedURL = URL(string: url) else { return }

        var request = URLRequest(url: unwrappedURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }

            do {
                let f1Data = try JSONDecoder().decode(Constructors.self, from: data)
                let thisArray = f1Data.data.constructorTable.constructors
                let season = f1Data.data.constructorTable.season?.capitalized

                let dispatchGroup = DispatchGroup()
                for i in Range(0...thisArray.count - 1){
                    Data.teamNames.append(thisArray[i].name)
                    Data.teamNationality.append(thisArray[i].nationality)
                    Data.teamURL.append(thisArray[i].url)
                    Data.constructorID.append(thisArray[i].constructorID)
                    Data.f1Season.append(season)
                    
                    guard let wikipediaURL = thisArray[i].url else { continue }
                    dispatchGroup.enter()
                    getWikipediaThumbnail(from: wikipediaURL) { thumbnailURLString in
                        Data.teamImgURL.append(thumbnailURLString)
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion()
                }
            } catch let error {
                print("Error decoding CONSTRUCTOR json data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    static func getWikipediaThumbnail(from wikipediaURL: String, completion: @escaping (String?) -> Void) {
        let baseURL = "https://en.wikipedia.org/w/api.php"
        let params = [
            "action": "query",
            "format": "json",
            "prop": "pageimages",
            "pithumbsize": "200",
            "titles": wikipediaURL.components(separatedBy: "/").last ?? "",
        ]
        guard let url = URL(string: "\(baseURL)?\(params.queryParameters)") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let wikipediaData = try JSONDecoder().decode(WikipediaData.self, from: data)
                let pageIDs = wikipediaData.query.pages.keys
                guard let pageID = pageIDs.first,
                      let thumbnail = wikipediaData.query.pages[pageID]?.thumbnail,
                      let thumbnailURLString = thumbnail.source
                else {
                    completion(nil)
                    return
                }
                completion(thumbnailURLString)
            } catch let error {
                print("Error decoding WIKIPEDIA json data: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

extension Dictionary {
    var queryParameters: String {
        var components = URLComponents()
        components.queryItems = self.map { key, value in
            URLQueryItem(name: "\(key)", value: "\(value)")
        }
        return components.percent
