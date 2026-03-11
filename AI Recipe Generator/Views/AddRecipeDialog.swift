//
//  AddRecipeDialog.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 07/03/26.
//
import SwiftUI

import SwiftUI

struct AddRecipeDialog: View {
    
    var onSubmit: (String, Cuisine) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var ingredients: String = ""
    @State private var cuisine: Cuisine = .italian
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Create Recipe")
                            .font(.title.bold())
                        
                        Text("Enter ingredients you already have and let AI generate a recipe.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // MARK: - Ingredients Input
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Ingredients")
                            .font(.headline)
                        
                        ZStack(alignment: .topLeading) {
                            
                            if ingredients.isEmpty {
                                Text("Example: tomato, garlic, pasta, olive oil")
                                    .foregroundColor(.gray.opacity(0.6))
                                    .padding(.top, 10)
                                    .padding(.leading, 6)
                            }
                            
                            TextEditor(text: $ingredients)
                                .frame(height: 120)
                                .padding(4)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.3))
                        )
                        
                        Text("Separate ingredients with commas.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // MARK: - Cuisine Picker
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Cuisine Style")
                            .font(.headline)
                        
                        Picker("Cuisine", selection: $cuisine) {
                            ForEach(Cuisine.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // MARK: - Tips
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Label("Tips for Better Recipes", systemImage: "lightbulb")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text("• Add 3–6 ingredients for best results")
                            Text("• Include protein like chicken, tofu, or beans")
                            Text("• Include spices for richer recipes")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    // MARK: - Generate Button
                    
                    Button {
                        
                        onSubmit(ingredients, cuisine)
                        dismiss()
                        
                    } label: {
                        
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Generate Recipe")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(ingredients.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
