//
//  RecipesView.swift
//  Fetchly
//
//  Created by Cleo Howard on 5/29/25.
//


import SwiftUI

struct RecipesView: View {
    @StateObject private var viewModel = RecipesViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()

                        Button("Try Again") {
                            Task {
                                await viewModel.loadRecipes()
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Recipes")
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
}

#Preview {
    NavigationView {
        List {
            NavigationLink(destination: Text("Recipe Detail")) {
                HStack {
                    Color.gray
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading) {
                        Text("Mock Pizza")
                            .font(.headline)
                        Text("Italian")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Recipes")
    }
}
