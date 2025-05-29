//
//  ImageCacheManager.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let fileManager = FileManager.default
    private let directory: URL

    init(directory: URL? = nil) {
        self.directory = directory ?? fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    func image(forKey key: String) -> Data? {
        let url = directory.appendingPathComponent(key)
        return try? Data(contentsOf: url)
    }

    func save(data: Data, forKey key: String) {
        let url = directory.appendingPathComponent(key)
        try? data.write(to: url)
    }

    func contains(key: String) -> Bool {
        let url = directory.appendingPathComponent(key)
        return fileManager.fileExists(atPath: url.path)
    }
}
