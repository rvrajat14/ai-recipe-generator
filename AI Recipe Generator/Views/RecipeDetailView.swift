//
//  RecipeDetailView.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 08/03/26.
//
import SwiftUI

struct RecipeDetailView: View {

    let recipe: Recipe

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                Text(recipe.title)
                    .font(.largeTitle.bold())

                Text("Cuisine: \(recipe.cuisine)")
                    .foregroundColor(.secondary)

                Text("Cooking Time: \(recipe.cookingTime)")

                Divider()

                Text("Ingredients")
                    .font(.title2.bold())

                ForEach(recipe.ingredients, id: \.self) {

                    Text("• \($0)")
                }

                Divider()

                Text("Instructions")
                    .font(.title2.bold())

                ForEach(
                    Array(recipe.instructions.enumerated()),
                    id: \.offset
                ) { index, step in

                    Text("\(index + 1). \(step)")
                }
            }
            .padding()
        }
        .navigationTitle("Recipe")
    }
}
