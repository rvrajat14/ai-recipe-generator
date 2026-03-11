//
//  RecipeCard.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 08/03/26.
//

import SwiftUI

struct RecipeCard: View {

    let recipe: Recipe

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text(recipe.title)
                .font(.headline)

            HStack {

                Image(systemName: "clock")

                Text(recipe.cookingTime)
            }
            .font(.caption)

        }
        .padding()
        .cornerRadius(14)
    }
}
