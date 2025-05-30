//
//  RecipeRowView.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        HStack {
            if let data = imageLoader.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                    Image(systemName: "photo")
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .task {
            await imageLoader.loadImage(from: recipe.photoURLSmall)
        }
    }
}

#Preview {
    let sampleRecipe = Recipe(
        id: UUID(),
        name: "Sample Pizza",
        cuisine: "Italian",
        photoURLLarge: URL(string: "https://example.com/large.jpg")!,
        photoURLSmall: URL(string: "https://via.placeholder.com/60")!,
        sourceURL: URL(string: "https://example.com"),
        youtubeURL: URL(string: "https://youtube.com")
    )
    
    return RecipeRowView(recipe: sampleRecipe)
}
