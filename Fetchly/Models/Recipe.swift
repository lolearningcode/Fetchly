//
//  Recipe.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLLarge: URL
    let photoURLSmall: URL
    let sourceURL: URL?
    let youtubeURL: URL?

    enum CodingKeys: String, CodingKey {
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
        case id = "uuid"
    }
}
