//
//  AddRecipeDialog.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 07/03/26.
//
import SwiftUI

import Speech

struct AddRecipeDialog: View {
    
    var onSubmit: (String, Cuisine) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var ingredients: String = ""
    @State private var cuisine: Cuisine = .italian
    
    @State private var speechService = SpeechRecognitionService()
    
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
                        
                        // Header row with mic button
                        HStack {
                            Text("Ingredients")
                                .font(.headline)
                            
                            Spacer()
                            
                            // Voice button
                            Button {
                                handleVoiceButton()
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: speechService.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(speechService.isRecording ? .red : .indigo)
                                        .symbolEffect(.pulse, isActive: speechService.isRecording)
                                    
                                    Text(speechService.isRecording ? "Stop" : "Voice")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(speechService.isRecording ? .red : .indigo)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    (speechService.isRecording ? Color.red : Color.indigo).opacity(0.1)
                                )
                                .clipShape(Capsule())
                            }
                            .disabled(speechService.authorizationStatus == .denied)
                        }
                        
                        // Live transcription indicator
                        if speechService.isRecording {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 8, height: 8)
                                    .symbolEffect(.pulse)
                                Text("Listening… speak your ingredients")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            .transition(.opacity)
                        }
                        
                        // Text editor
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
                                .stroke(
                                    speechService.isRecording ? Color.red.opacity(0.5) : Color.gray.opacity(0.3),
                                    lineWidth: speechService.isRecording ? 2 : 1
                                )
                                .animation(.easeInOut, value: speechService.isRecording)
                        )
                        
                        // Error message
                        if let error = speechService.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        
                        // Hint
                        HStack {
                            Text("Separate ingredients with commas.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !speechService.transcribedText.isEmpty && !speechService.isRecording {
                                Button("Clear") {
                                    ingredients = ""
                                    speechService.transcribedText = ""
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onAppear {
                        speechService.requestAuthorization()
                    }
                    .onChange(of: speechService.transcribedText) { _, newValue in
                        // Append transcribed text to existing ingredients
                        if !newValue.isEmpty {
                            ingredients = newValue
                        }
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
    
    private func handleVoiceButton() {
        if speechService.isRecording {
            speechService.stopRecording()
        } else {
            switch speechService.authorizationStatus {
            case .authorized:
                speechService.startRecording()
            case .notDetermined:
                speechService.requestAuthorization()
            case .denied, .restricted:
                speechService.errorMessage = "Microphone access denied. Enable it in Settings."
            @unknown default:
                break
            }
        }
    }
    
}

