//
//  CacheManager.swift
//  F1App
//
//  Created by Arman Husic on 10/30/24.
//

import Foundation
import SwiftUI

extension FileManager {
    static let imageCacheDirectory: URL = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let imageCacheDir = directory.appendingPathComponent("ImageCache")
        if !FileManager.default.fileExists(atPath: imageCacheDir.path) {
            try? FileManager.default.createDirectory(at: imageCacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        return imageCacheDir
    }()
    
    func cachedImagePath(for identifier: String) -> URL {
        return FileManager.imageCacheDirectory.appendingPathComponent("\(identifier).png")
    }
    
    func saveImageDataToCache(_ data: Data, for identifier: String) {
        let path = cachedImagePath(for: identifier)
        try? data.write(to: path)
    }
    
    func loadCachedImageData(for identifier: String) -> Data? {
        let path = cachedImagePath(for: identifier)
        return try? Data(contentsOf: path)
    }
}
