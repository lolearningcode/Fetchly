//
//  RecipeServiceTests.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//


import XCTest
@testable import Fetchly

final class RecipeServiceTests: XCTestCase {

    private func makeTestSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    func testFetchRecipesSuccessReturnsRecipes() async throws {
        let json = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com",
                    "uuid": "0C6CA6E7-E32A-4053-B824-1DBF749910D8",
                    "youtube_url": "https://youtube.com/example"
                }
            ]
        }
        """

        let data = Data(json.utf8)
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        MockURLProtocol.requestHandler = { _ in (data, response) }

        let session = makeTestSession()
        let service = RecipeService(session: session)

        let recipes = try await service.fetchRecipes("https://example.com")

        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
    }

    func testFetchRecipesInvalidResponseThrows() async {
        let data = Data()
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: nil)!

        MockURLProtocol.requestHandler = { _ in (data, response) }

        let session = makeTestSession()
        let service = RecipeService(session: session)

        do {
            _ = try await service.fetchRecipes("https://example.com")
            XCTFail("Expected to throw invalidResponse error")
        } catch let error as RecipeServiceError {
            XCTAssertEqual(error.localizedDescription, RecipeServiceError.invalidResponse.localizedDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchRecipesDecodingFailureThrows() async {
        let badJSON = "{ bad: json }"
        let data = Data(badJSON.utf8)
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        MockURLProtocol.requestHandler = { _ in (data, response) }

        let session = makeTestSession()
        let service = RecipeService(session: session)

        do {
            _ = try await service.fetchRecipes("https://example.com")
            XCTFail("Expected to throw decodingFailed")
        } catch let error as RecipeServiceError {
            XCTAssertEqual(error.localizedDescription, RecipeServiceError.decodingFailed.localizedDescription)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRecipesWithMalformedEndpoint() async {
        let service = RecipeService()
        do {
            _ = try await service.fetchRecipes(RecipeEndpoint.malformed)
            XCTFail("Expected to throw decodingFailed for malformed data")
        } catch {
            let expectedDescription = RecipeServiceError.decodingFailed.errorDescription
            let actualDescription = (error as? LocalizedError)?.errorDescription
            XCTAssertEqual(actualDescription, expectedDescription, "Expected decodingFailed, but got: \(String(describing: actualDescription))")
        }
    }
    
    func testFetchRecipesWithEmptyEndpoint() async {
        let service = RecipeService()
        do {
            let recipes = try await service.fetchRecipes(RecipeEndpoint.empty)
            XCTAssertTrue(recipes.isEmpty)
        } catch {
            XCTFail("Expected empty list, but got error: \(error)")
        }
    }
}
