//
//  RecipeTests.swift
//  FetchlyTests
//
//  Created by Cleo Howard on 5/29/25.
//

import XCTest
@testable import Fetchly

final class RecipeTests: XCTestCase {
    
    func testRecipeResponseDecoding() throws {
        let json = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com/recipe",
                    "uuid": "0C6CA6E7-E32A-4053-B824-1DBF749910D8",
                    "youtube_url": "https://youtube.com/example"
                }
            ]
        }
        """
        
        let jsonData = Data(json.utf8)
        let decoded = try JSONDecoder().decode(RecipeResponse.self, from: jsonData)
        
        XCTAssertEqual(decoded.recipes.count, 1)
        
        let recipe = decoded.recipes[0]
        XCTAssertEqual(recipe.name, "Apam Balik")
        XCTAssertEqual(recipe.cuisine, "Malaysian")
        XCTAssertEqual(recipe.id.uuidString, "0C6CA6E7-E32A-4053-B824-1DBF749910D8")
        XCTAssertEqual(recipe.photoURLLarge.absoluteString, "https://example.com/large.jpg")
        XCTAssertEqual(recipe.sourceURL?.absoluteString, "https://example.com/recipe")
        XCTAssertEqual(recipe.youtubeURL?.absoluteString, "https://youtube.com/example")
    }
    
    func testRecipeDecodingWithoutOptionalFields() throws {
        let json = """
    {
        "recipes": [
            {
                "cuisine": "British",
                "name": "Jam Roly-Poly",
                "photo_url_large": "https://example.com/large.jpg",
                "photo_url_small": "https://example.com/small.jpg",
                "uuid": "123e4567-e89b-12d3-a456-426614174000"
            }
        ]
    }
    """
        
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
        
        XCTAssertEqual(decoded.recipes.count, 1)
        let recipe = decoded.recipes[0]
        XCTAssertEqual(recipe.name, "Jam Roly-Poly")
        XCTAssertNil(recipe.sourceURL)
        XCTAssertNil(recipe.youtubeURL)
    }
}
