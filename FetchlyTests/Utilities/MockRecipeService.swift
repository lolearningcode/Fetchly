//
//  MockRecipeService.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import Foundation
@testable import Fetchly

final class MockRecipeService: RecipeFetching {
    var result: Result<[Recipe], Error> = .success([])

    func fetchRecipes(_ urlString: String) async throws -> [Recipe] {
        switch result {
        case .success(let recipes): return recipes
        case .failure(let error): throw error
        }
    }
}
