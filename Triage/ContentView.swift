//
//  ContentView.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\Feature.eloRank, order: .forward)])
    private var features: [Feature]
    
    @State
    private var showingAddSheet: Bool = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(features, id: \.id) { feature in
                    VStack(alignment: .leading) {
                        LabeledContent {
                            Text("\(feature.eloRank)")
                        } label: {
                            Text(feature.title)
                        }
                        
                        HStack {
                            Text("Fuck")
                            Text("Suck")
                            Text("Cum")
                            Text("Jizz")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
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
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem(title: String) {
        withAnimation {
            let newItem = Feature(
                title: title,
                eloRank: 0
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
        let feature = Feature(title: "Feature (\(i))", eloRank: 1200)
        container.mainContext.insert(feature)
    }
    
    return ContentView()
        .modelContainer(container)
}
