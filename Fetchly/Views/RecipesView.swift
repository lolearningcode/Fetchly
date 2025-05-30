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
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        
                        Text("Oops! Something went wrong.")
                            .font(.title3)
                            .bold()
                        
                        Text(errorMessage)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button(action: {
                            Task {
                                await viewModel.loadRecipes()
                            }
                        }) {
                            Text("Try Again")
                                .bold()
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                                    Text(cuisine)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(viewModel.selectedCuisine == cuisine ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(viewModel.selectedCuisine == cuisine ? .white : .primary)
                                        .clipShape(Capsule())
                                        .onTapGesture {
                                            viewModel.selectedCuisine = cuisine
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                        
                        List {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeRowView(recipe: recipe)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            await viewModel.loadRecipes()
                        }
                    }
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
