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
    @Published var image: UIImage?
    
    func loadImage(from url: URL) async {
        let key = url.absoluteString.sha256()
        
        if let cachedData = ImageCacheManager.shared.image(forKey: key) {
            if let decoded = await decodeImage(from: cachedData) {
                self.image = decoded
            }
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                print("Image load failed: Invalid response or status code")
                return
            }
            
            guard !data.isEmpty else {
                print("Image load failed: Empty data")
                return
            }
            
            ImageCacheManager.shared.save(data: data, forKey: key)
            
            if let decoded = await decodeImage(from: data) {
                self.image = decoded
            }
        } catch {
            print("Image load failed: \(error)")
        }
    }
    
    private func decodeImage(from data: Data) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let image = UIImage(data: data)
                continuation.resume(returning: image)
            }
        }
    }
}

extension String {
    func sha256() -> String {
        let hash = SHA256.hash(data: Data(self.utf8))
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
