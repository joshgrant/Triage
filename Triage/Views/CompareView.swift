//
//  CompareView.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI
import SwiftData
import EloRater

struct CompareView: View {
    
    enum Result {
        case aWins
        case bWins
        case tie
        
        var value: Double {
            switch self {
            case .aWins: return 1
            case .bWins: return 0
            case .tie: return 0.5
            }
        }
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: [SortDescriptor(\Dimension.weight, order: .forward)])
    private var dimensions: [Dimension]
    
    @State
    private var selection: Int = 0
    
    @State
    var featureA: Feature
    
    @State
    var featureB: Feature
    
    var featureCount: Int
    var historyCount: Int
    
    var recommended: Int {
        Int(ceil(Float(featureCount) * log2(Float(max(featureCount, 2)))))
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(dimensions.enumerated(), id: \.element.id) { (offset, dimension) in
                Tab(value: offset) {
                    VStack(spacing: 20) {
                        if featureCount < recommended {
                            Text("You've rated \(historyCount) items. \(recommended) reccomended")
                        }
                        
                        Text(dimensionLabel(dimension: dimension, item: offset, total: dimensions.count))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(dimension.explanation)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        
                        Button {
                            vote(
                                a: featureA,
                                b: featureB,
                                dimension: dimension,
                                result: .aWins
                            )
                            moveToNext(result: .aWins, dimension: dimension)
                        } label: {
                            Text(featureA.title)
                                .font(.title2)
                                .bold()
                        }
                        .controlSize(.extraLarge)
                        .buttonStyle(.borderedProminent)
                        .buttonSizing(.flexible)
                        
                        Button {
                            vote(
                                a: featureA,
                                b: featureB,
                                dimension: dimension,
                                result: .bWins
                            )
                            moveToNext(result: .bWins, dimension: dimension)
                        } label: {
                            Text(featureB.title)
                                .font(.title2)
                                .bold()
                        }
                        .controlSize(.extraLarge)
                        .buttonStyle(.borderedProminent)
                        .buttonSizing(.flexible)
                        
                        Button {
                            vote(
                                a: featureA,
                                b: featureB,
                                dimension: dimension,
                                result: .tie
                            )
                            moveToNext(result: .tie, dimension: dimension)
                        } label: {
                            Text("Skip")
                        }
                    }
                    .padding()
                }
            }
        }
        .tabViewStyle(.page)
        .navigationTitle("Compare")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func dimensionLabel(
        dimension: Dimension,
        item: Int,
        total: Int
    ) -> String {
        "\(dimension.label) (\(item + 1)/\(total))"
    }
    
    /// Result is `1` if `a` won
    /// Result is `0` if `b` won
    /// Result is `0.5` if there was a draw
    private func vote(
        a: Feature,
        b: Feature,
        dimension: Dimension,
        result: Result
    ) {
        guard
            let ratingA = a.ratings.first(where: { $0.dimension == dimension }),
            let ratingB = b.ratings.first(where: { $0.dimension == dimension })
        else {
            assertionFailure("Failed to find ratings that matched the given dimensions")
            return
        }
        
        let (newA, newB) = newRatings(
            a: ratingA.value,
            b: ratingB.value,
            result: result.value
        )
        
        ratingA.value = newA
        ratingB.value = newB
    }
    
    private func moveToNext(result: Result, dimension: Dimension) {
        featureA.update()
        featureB.update()
        
        let selectedFeature: Feature? = switch result {
        case .aWins: featureA
        case .bWins: featureB
        case .tie: nil
        }
        
        let history = History(
            timestamp: .now,
            featureA: featureA,
            featureB: featureB,
            dimension: dimension,
            selectedFeature: selectedFeature
        )
        
        modelContext.insert(history)
        
        withAnimation {
            selection += 1
        }
        
        if selection >= dimensions.count {
            dismiss()
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dimension.self, configurations: configuration)
    
    var ratings: [Rating] = []
    
    for i in 0 ..< 5 {
        let dimension = Dimension(
            label: "User Impact",
            explanation: "Which will matter more to users?",
            weight: 3
        )
        container.mainContext.insert(dimension)
        
        let rating = Rating(value: 0, dimension: dimension)
        ratings.append(rating)
    }
    
    let featureA = Feature(
        title: "Butter on Toast",
        ratings: ratings
    )
    
    let featureB = Feature(
        title: "Avocado on Toast",
        ratings: ratings
    )
    
    return NavigationStack {
        CompareView(
            featureA: featureA,
            featureB: featureB,
            featureCount: 2,
            historyCount: 0,
        )
    }
    .modelContainer(container)
}
