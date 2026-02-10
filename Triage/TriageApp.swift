//
//  TriageApp.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI
import SwiftData

@main
struct TriageApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Feature.self,
            Rating.self,
            History.self,
            Dimension.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            populateDatabase(in: container)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FeatureListView()
        }
        .modelContainer(sharedModelContainer)
    }
}

private func populateDatabase(in container: ModelContainer) {
    let descriptor = FetchDescriptor<Dimension>()
    let existingCount = (try? container.mainContext.fetchCount(descriptor)) ?? 0

    guard existingCount == 0 else { return }

    let defaults: [(String, String, Int)] = [
        ("User Impact", "Which matters more to users?", 3),
        ("Effort", "Which is easier to implement?", 3),
        ("Alignment", "Which aligns better with the current goal?", 2),
        ("Confidence", "Which one has more data to support its need?", 2),
        ("Urgency", "Which one loses more value if delayed?", 1),
        ("Dependencies", "Which one has fewer dependencies?", 1),
    ]

    for (label, explanation, weight) in defaults {
        let dimension = Dimension(label: label, explanation: explanation, weight: weight)
        container.mainContext.insert(dimension)
    }
}
