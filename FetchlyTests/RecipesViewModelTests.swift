//
//  RecipesViewModelTests.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import XCTest
@testable import Fetchly

@MainActor
final class RecipesViewModelTests: XCTestCase {

    func testLoadRecipesSuccess() async {
        let mockService = MockRecipeService()
        let recipe: Recipe = Recipe(
            id: UUID(),
            name: "Test Recipe",
            cuisine: "Test",
            photoURLLarge: URL(string: "https://example.com/small.jpg")!,
            photoURLSmall: URL(string: "https://example.com/large.jpg")!,
            sourceURL: URL(string: "https://example.com")!,
            youtubeURL: URL(string: "https://youtube.com")!
        )
        mockService.result = Result<[Recipe], Error>.success([recipe])
        
        let viewModel = RecipesViewModel(service: mockService)

        await viewModel.loadRecipes()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes.count, 1)
    }

    func testLoadRecipesEmpty() async {
        let mockService = MockRecipeService()
        mockService.result = Result<[Recipe], Error>.success([])

        let viewModel = RecipesViewModel(service: mockService)

        await viewModel.loadRecipes()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertEqual(viewModel.errorMessage, "No recipes available right now.")
    }

    func testLoadRecipesFailure() async {
        let mockService = MockRecipeService()
        mockService.result = Result<[Recipe], Error>.failure(RecipeServiceError.invalidResponse)

        let viewModel = RecipesViewModel(service: mockService)

        await viewModel.loadRecipes()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertEqual(viewModel.errorMessage, RecipeServiceError.invalidResponse.errorDescription)
    }
}
