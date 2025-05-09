//
//  TechnicalTestInstaApp.swift
//  TechnicalTestInsta
//
//  Created by Teddy Bérard on 16/04/2025.
//

import SwiftUI
import SwiftData

@main
struct TechnicalTestInstaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StoryItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
