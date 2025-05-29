//
//  ImageLoader.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation
import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published var imageData: Data?

    func loadImage(from url: URL) async {
        let key = url.lastPathComponent
        
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
