//
//  ImageLoader.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation
import SwiftUI
import CryptoKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published var imageData: Data?

    func loadImage(from url: URL) async {
        let key = url.absoluteString.sha256() // Keep keys unique
        
        if let cached = ImageCacheManager.shared.image(forKey: key) {
            self.imageData = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            ImageCacheManager.shared.save(data: data, forKey: key)
            self.imageData = data
        } catch {
            print("Image load failed: \(error)")
        }
    }
}

extension String {
    func sha256() -> String {
        let hash = SHA256.hash(data: Data(self.utf8))
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
