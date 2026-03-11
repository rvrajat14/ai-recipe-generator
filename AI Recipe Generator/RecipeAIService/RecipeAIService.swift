//
//  RecipeAPIService.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 08/03/26.
//

import Foundation
import FoundationModels

@available(iOS 26.0, *)
class RecipeAIService {

    private let session = LanguageModelSession()


    // MARK: - Normal generation
    func generateRecipe(
        ingredients: String,
        cuisine: Cuisine
    ) async throws -> RecipeDTO {

        let prompt = buildPrompt(
            ingredients: ingredients,
            cuisine: cuisine
        )

        let response = try await session.respond(to: prompt)

        let cleaned = extractJSON(from: response.content)

        guard let jsonData = cleaned.data(using: .utf8) else {
            throw NSError(domain: "RecipeAIService", code: 1)
        }

        return try JSONDecoder().decode(RecipeDTO.self, from: jsonData)
    }

    // MARK: - Streaming generation
    func streamRecipe(
        ingredients: String,
        cuisine: Cuisine,
        onUpdate: @escaping (String) -> Void
    ) async throws {

        let prompt = buildPrompt(
            ingredients: ingredients,
            cuisine: cuisine
        )

        let stream = try session.streamResponse(to: prompt)

        for try await snapshot in stream {
            onUpdate(snapshot.content)
        }
    }
    
    private func extractJSON(from text: String) -> String {

        if let start = text.firstIndex(of: "{"),
           let end = text.lastIndex(of: "}") {

            return String(text[start...end])
        }

        return text
    }

    private func buildPrompt(
        ingredients: String,
        cuisine: Cuisine
    ) -> String {

"""
You are a professional chef.

Create a \(cuisine.rawValue) style recipe using ONLY the following ingredients:

\(ingredients)

Return ONLY valid JSON:

{
"title": "",
"ingredients": [],
"instructions": [],
"cookingTime": ""
}
"""
    }
}
