//
//  AI_Recipe_GeneratorApp.swift
//  AI Recipe Generator
//
//  Created by Rajat Verma on 07/03/26.
//

import SwiftUI
import SwiftData

@main
struct AI_Recipe_GeneratorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView(context: sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
