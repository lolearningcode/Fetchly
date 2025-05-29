//
//  RecipesViewModel.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation

@MainActor
final class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service: RecipeFetching
    
    init(service: RecipeFetching = RecipeService()) {
        self.service = service
    }
    
    func loadRecipes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipes = try await service.fetchRecipes()
            
            if fetchedRecipes.isEmpty {
                errorMessage = "No recipes available right now."
                recipes = []
            } else {
                recipes = fetchedRecipes
            }
            
        } catch let error as RecipeServiceError {
            errorMessage = error.errorDescription
            recipes = []
        } catch {
            errorMessage = "Something went wrong."
            recipes = []
        }
        
        isLoading = false
    }
}
