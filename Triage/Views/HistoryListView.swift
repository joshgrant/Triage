//
//  HistoryListView.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI
import SwiftData

struct HistoryListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\History.timestamp, order: .reverse)])
    private var historyItems: [History]
    
    var body: some View {
        List {
            ForEach(historyItems, id: \.id) { item in
                LabeledContent {
                    Text(item.timestamp.formatted())
                } label: {
                    Text(content(item: item))
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func content(item: History) -> String {
        if item.selectedFeature == item.featureA {
            "\(item.featureA.title) > \(item.featureB.title)"
        } else if item.selectedFeature == item.featureB {
            "\(item.featureB.title) > \(item.featureA.title)"
        } else {
            "\(item.featureB.title) == \(item.featureA.title)"
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: History.self, configurations: configuration)
    
    let dimension = Dimension(
        label: "Dimension",
        explanation: "Which one is more dimensional?",
        weight: 1
    )
    
    let featureA = Feature(title: "Onboarding", ratings: [])
    let featureB = Feature(title: "Preferences", ratings: [])
    
    let feature = History(
        timestamp: Date(),
        featureA: featureA,
        featureB: featureB,
        dimension: dimension,
        selectedFeature: featureA)
    container.mainContext.insert(feature)
    
    let feature2 = History(
        timestamp: Date(),
        featureA: featureA,
        featureB: featureB,
        dimension: dimension,
        selectedFeature: featureB)
    container.mainContext.insert(feature2)
    
    let feature3 = History(
        timestamp: Date(),
        featureA: featureA,
        featureB: featureB,
        dimension: dimension,
        selectedFeature: nil)
    container.mainContext.insert(feature3)
    
    return NavigationStack {
        HistoryListView()
            .modelContainer(container)
    }
}
