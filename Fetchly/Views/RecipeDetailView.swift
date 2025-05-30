//
//  RecipeDetailView.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//


import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @StateObject private var imageLoader: ImageLoader
    
    init(recipe: Recipe) {
        self.recipe = recipe
        _imageLoader = StateObject(wrappedValue: ImageLoader())
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let uiImage = imageLoader.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                } else {
                    ZStack {
                        Color.gray.opacity(0.2)
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 40))
                    }
                }
                
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
        .task {
            await imageLoader.loadImage(from: recipe.photoURLLarge)
        }
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
