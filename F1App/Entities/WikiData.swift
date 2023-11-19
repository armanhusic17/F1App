//
//  WikiData.swift
//  F1App
//
//  Created by Arman Husic on 11/19/23.
//

import Foundation


struct WikipediaData: Codable {
    struct Query: Codable {
        struct Page: Codable {
            struct Thumbnail: Codable {
                let source: String
            }
            let thumbnail: Thumbnail?
        }
        let pages: [String: Page]
    }
    let query: Query
}


struct WikipediaImage: Decodable {
    let source: String
}

struct WikipediaQuery: Decodable {
    let pages: [String: WikipediaPage]
}

struct WikipediaPage: Decodable {
    let thumbnail: WikipediaThumbnail?
    let originalimage: WikipediaImage?
}

struct WikipediaThumbnail: Decodable {
    let source: String
}
