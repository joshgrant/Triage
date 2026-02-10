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
            Rating.self
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

private func populateDatabase(in container: ModelContainer) {
    let userImpact = Dimension(
        label: "User Impact",
        explanation: "Which matters more to users?",
        weight: 3
    )
    
    let effort = Dimension(
        label: "Effort",
        explanation: "Which is easier to implement?",
        weight: 3
    )
    
    let alignment = Dimension(
        label: "Alignment",
        explanation: "Which aligns better with the current goal?",
        weight: 2
    )
    
    let confidence = Dimension(
        label: "Confidence",
        explanation: "Which one has more data to support its need?",
        weight: 2
    )
    
    let opportunity = Dimension(
        label: "Urgency",
        explanation: "Which one loses more value if delayed?",
        weight: 1
    )
    
    let dependency = Dimension(
        label: "Dependencies",
        explanation: "Which one has fewer dependencies?",
        weight: 1
    )
    
    container.mainContext.insert(userImpact)
    container.mainContext.insert(effort)
    container.mainContext.insert(alignment)
    container.mainContext.insert(confidence)
    container.mainContext.insert(opportunity)
    container.mainContext.insert(dependency)
}
