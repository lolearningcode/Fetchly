//
//  RecipeService.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation

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
