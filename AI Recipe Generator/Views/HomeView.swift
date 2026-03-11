//
//  ContentView.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 07/03/26.
//

import SwiftUI
import SwiftData
import Combine


struct HomeView: View {

    @Environment(\.modelContext) private var context

    @StateObject private var viewModel: RecipeViewModel

    @State private var showDialog = false

    init(context: ModelContext) {
        _viewModel = StateObject(
            wrappedValue: RecipeViewModel(context: context)
        )
    }

    var body: some View {

        NavigationStack {

            List {

                ForEach(viewModel.recipes, id: \.id) { recipe in

                    NavigationLink(value: recipe) {
                        RecipeCard(recipe: recipe)
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            .navigationTitle("Recipes")
            .toolbar {

                Button {

                    showDialog = true

                } label: {

                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showDialog) {

                AddRecipeDialog { ingredients, cuisine in
                    viewModel.generateRecipe(
                        ingredients: ingredients,
                        cuisine: cuisine
                    )
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
         for: Recipe.self,
         configurations: ModelConfiguration(isStoredInMemoryOnly: true)
     )
    HomeView(context: container.mainContext)
        .modelContainer(container)
}
