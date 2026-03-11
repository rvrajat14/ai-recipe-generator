//
//  RecipeViewModel.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 08/03/26.
//
import SwiftData
import Combine
import Foundation

class RecipeViewModel: ObservableObject {

    private let context: ModelContext

    @Published var recipes: [Recipe] = []
    @Published var selectedRecipe: Recipe?

    init(context: ModelContext) {
        self.context = context
        fetchRecipes()
    }

    // MARK: Fetch

    func fetchRecipes() {

        do {

            let descriptor = FetchDescriptor<Recipe>(
                sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
            )

            recipes = try context.fetch(descriptor)

        } catch {

            print("Fetch failed:", error)
        }
    }

    // MARK: Generate

    func generateRecipe(
        ingredients: String,
        cuisine: Cuisine
    ) {

        Task {

            do {

                if #available(iOS 26.0, *) {
                    let dto = try await RecipeAIService()
                        .generateRecipe(
                            ingredients: ingredients,
                            cuisine: cuisine
                        )
                    
                    let recipe = Recipe(
                        title: dto.title,
                        ingredients: dto.ingredients,
                        instructions: dto.instructions,
                        cookingTime: dto.cookingTime,
                        cuisine: cuisine.rawValue
                    )

                    saveRecipe(recipe)

                    DispatchQueue.main.async {
                        self.selectedRecipe = recipe
                    }
                } else {
                    // Fallback on earlier versions
                }


            } catch {

                print("Generation failed:", error)
            }
        }
    }

    // MARK: Save

    func saveRecipe(_ recipe: Recipe) {

        context.insert(recipe)
        fetchRecipes()
    }

    // MARK: Delete

    func deleteItems(offsets: IndexSet) {

        for index in offsets {

            let recipe = recipes[index]
            context.delete(recipe)
        }

        fetchRecipes()
    }
}
