//
//  RecipeDetailView.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//


import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: recipe.photoURLLarge) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(maxWidth: .infinity)

                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.subheadline)

                if let sourceURL = recipe.sourceURL {
                    Link("View Source", destination: sourceURL)
                }
                
                if let youtubeURL = recipe.youtubeURL {
                    Link("Watch on YouTube", destination: youtubeURL)
                }
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let sampleRecipe = Recipe(
        id: UUID(),
        name: "Sample Recipe",
        cuisine: "Fusion",
        photoURLLarge: URL(string: "https://example.com/large.jpg")!,
        photoURLSmall: URL(string: "https://example.com/small.jpg")!,
        sourceURL: URL(string: "https://example.com"),
        youtubeURL: URL(string: "https://youtube.com")
    )
    
    return NavigationView {
        RecipeDetailView(recipe: sampleRecipe)
    }
}
