//
//  Item.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 07/03/26.
//

import Foundation
import SwiftData

@Model
final class Recipe {

    var id: UUID
    var title: String
    var ingredients: [String]
    var instructions: [String]
    var cookingTime: String
    var cuisine: String
    var timestamp: Date

    init(
        title: String,
        ingredients: [String],
        instructions: [String],
        cookingTime: String,
        cuisine: String
    ) {
        self.id = UUID()
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
        self.cookingTime = cookingTime
        self.cuisine = cuisine
        self.timestamp = Date()
    }
}


struct RecipeDTO: Codable {

    let title: String
    let ingredients: [String]
    let instructions: [String]
    let cookingTime: String
}


enum Cuisine: String, CaseIterable {

    case italian = "Italian"
    case indian = "Indian"
    case mexican = "Mexican"
    case asian = "Asian"
}
