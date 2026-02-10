//
//  ContentView.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI
import SwiftData

struct FeatureListView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Feature.compositeRating, order: .reverse)])
    private var features: [Feature]
    
    @Query
    private var history: [History]
    
    @Query
    private var dimensions: [Dimension]
    
    @State
    private var showingAddSheet: Bool = false
    
    @State
    private var showingCompareSheet: Bool = false
    
    @State
    private var showingHistorySheet: Bool = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(features, id: \.id) { feature in
                    VStack(alignment: .leading) {
                        LabeledContent {
                            Text("\(feature.compositeRating)")
                        } label: {
                            Text(feature.title)
                        }
                        
                        HStack(spacing: 2) {
                            ForEach(feature.ratings, id: \.id) { rating in
                                RatingView(rating: rating)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingHistorySheet = true
                    } label: {
                        Text("History")
                    }
                }
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                
                if features.count >= 2 {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showingCompareSheet = true
                        } label: {
                            Text("Compare")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    NewFeatureView { title in
                        if let title {
                            addItem(title: title)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCompareSheet) {
                if let (a, b) = pickPair(features: features, history: history) {
                    NavigationStack {
                        CompareView(
                            featureA: a,
                            featureB: b,
                            featureCount: features.count,
                            historyCount: history.count
                        )
                    }
                }
            }
            .sheet(isPresented: $showingHistorySheet) {
                NavigationStack {
                    HistoryListView()
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem(title: String) {
        withAnimation {
            let newItem = Feature(
                title: title,
                ratings: dimensions.map {
                    .init(value: 1200, dimension: $0)
                }
            )
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(features[index])
            }
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Feature.self, configurations: configuration)
    
    for i in 0 ..< 10 {
        let feature = Feature(
            title: "Feature (\(i))",
            ratings: []
        )
        container.mainContext.insert(feature)
    }
    
    return FeatureListView()
        .modelContainer(container)
}
