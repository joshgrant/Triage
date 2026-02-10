//
//  FeatureListView.swift
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

    /// Number of unique pair comparison sessions (not individual dimension votes).
    private var comparisonCount: Int {
        guard !dimensions.isEmpty else { return 0 }
        return history.count / dimensions.count
    }

    var body: some View {
        NavigationSplitView {
            Group {
                if features.isEmpty {
                    ContentUnavailableView(
                        "No Features",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Add features to start comparing and prioritizing them.")
                    )
                } else {
                    List {
                        ForEach(features, id: \.id) { feature in
                            VStack(alignment: .leading) {
                                LabeledContent {
                                    Text("\(feature.compositeRating)")
                                } label: {
                                    Text(feature.title)
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 2) {
                                        let sortedRatings = feature.ratings.sorted { a, b in
                                            a.dimension.persistentModelID > b.dimension.persistentModelID
                                        }
                                        ForEach(sortedRatings, id: \.id) { rating in
                                            RatingView(rating: rating)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {

#if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    historyButton
                }
                #else
                ToolbarItem {
                    historyButton
                }
                #endif
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
#if os(iOS)
                    ToolbarItem(placement: .bottomBar) {
                        compareButton
                    }
#else
                    ToolbarItem {
                        compareButton
                    }
#endif
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
                            comparisonCount: comparisonCount
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

    private var compareButton: some View {
        Button {
            showingCompareSheet = true
        } label: {
            Text("Compare")
        }
    }
    
    private var historyButton: some View {
        Button {
            showingHistorySheet = true
        } label: {
            Text("History")
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
                let feature = features[index]

                // Remove history entries that reference this feature
                for entry in history where entry.featureA == feature || entry.featureB == feature {
                    modelContext.delete(entry)
                }

                modelContext.delete(feature)
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
