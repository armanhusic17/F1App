//
//  CacheManager.swift
//  F1App
//
//  Created by Arman Husic on 10/30/24.
//

import Foundation
import SwiftUI

extension FileManager {
    static let cacheDirectory: URL = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return directory
    }()
    
    static let imageCacheDirectory: URL = {
        let imageCacheDir = cacheDirectory.appendingPathComponent("ImageCache")
        if !FileManager.default.fileExists(atPath: imageCacheDir.path) {
            try? FileManager.default.createDirectory(at: imageCacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        return imageCacheDir
    }()
    
    static let jsonCacheDirectory: URL = {
        let jsonCacheDir = cacheDirectory.appendingPathComponent("JSONCache")
        if !FileManager.default.fileExists(atPath: jsonCacheDir.path) {
            try? FileManager.default.createDirectory(at: jsonCacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        return jsonCacheDir
    }()
    
    static let textCacheDirectory: URL = {
        let textCacheDir = cacheDirectory.appendingPathComponent("TextCache")
        if !FileManager.default.fileExists(atPath: textCacheDir.path) {
            try? FileManager.default.createDirectory(at: textCacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        return textCacheDir
    }()
    
    func cachedImagePath(for identifier: String) -> URL {
        return FileManager.imageCacheDirectory.appendingPathComponent("\(identifier).png")
    }
    
    func cachedJSONPath(for identifier: String) -> URL {
        return FileManager.jsonCacheDirectory.appendingPathComponent("\(identifier).json")
    }
    
    func cachedTextPath(for identifier: String) -> URL {
        return FileManager.jsonCacheDirectory.appendingPathComponent("\(identifier).txt")
    }
    
    func saveImageDataToCache(_ data: Data, for identifier: String) {
        let path = cachedImagePath(for: identifier)
        try? data.write(to: path)
    }
    
    func saveJSONDataToCache(_ data: Data, for identifier: String) {
        let path = cachedJSONPath(for: identifier)
        try? data.write(to: path)
    }
    
    func saveTextDataToCache(_ data: Data, for identifier: String) {
        let path = cachedTextPath(for: identifier)
        try? data.write(to: path)
    }
    
    func loadCachedImageData(for identifier: String) -> Data? {
        let path = cachedImagePath(for: identifier)
        return try? Data(contentsOf: path)
    }
    
    func loadCachedJSONData(for identifier: String) -> Data? {
        let path = cachedJSONPath(for: identifier)
        return try? Data(contentsOf: path)
    }
    
    func loadCachedTextData(for identifier: String) -> Data? {
        let path = cachedTextPath(for: identifier)
        return try? Data(contentsOf: path)
    }

}
