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
    
    @Published var selectedCuisine: String = "All"
    
    var filteredRecipes: [Recipe] {
        guard selectedCuisine != "All" else { return recipes }
        return recipes.filter { $0.cuisine == selectedCuisine }
    }
    
    var availableCuisines: [String] {
        let cuisines = Set(recipes.map { $0.cuisine })
        return ["All"] + cuisines.sorted()
    }
    
    private let service: RecipeFetching
    
    init(service: RecipeFetching = RecipeService()) {
        self.service = service
    }
    
    func loadRecipes(_ urlString: String = RecipeEndpoint.all.description) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipes = try await service.fetchRecipes(urlString)
            
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
