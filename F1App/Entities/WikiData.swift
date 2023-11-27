//
//  WikiData.swift
//  F1App
//
//  Created by Arman Husic on 11/19/23.
//

import Foundation


struct WikipediaData: Decodable {
    let query: Query

    struct Query: Decodable {
        let pages: [String: Page]
    }

    struct Page: Decodable {
        let thumbnail: Thumbnail?
    }

    struct Thumbnail: Decodable {
        let source: String
    }
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
