//
//  RecipeServiceError.swift
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
