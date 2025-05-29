//
//  RecipeService.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation

enum RecipeServiceError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case requestFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was invalid."
        case .invalidResponse:
            return "The server response was invalid."
        case .decodingFailed:
            return "Failed to decode recipes."
        case .requestFailed(let error):
            return error.localizedDescription
        }
    }
    
    static func == (lhs: RecipeServiceError, rhs: RecipeServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.invalidResponse, .invalidResponse),
            (.decodingFailed, .decodingFailed):
            return true
        case (.requestFailed, .requestFailed):
            return true
        default:
            return false
        }
    }
}

protocol RecipeFetching {
    func fetchRecipes() async throws -> [Recipe]
}

class RecipeService: RecipeFetching {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw RecipeServiceError.invalidResponse
            }
            
            do {
                let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
                return decoded.recipes
            } catch {
                throw RecipeServiceError.decodingFailed
            }
            
        } catch {
            throw RecipeServiceError.requestFailed(error)
        }
    }
}
