//
//  Feature.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

@Model
final class Feature {
    
    // MARK: - Properties
    
    private(set) var title: String
    private(set) var ratings: [Rating]
    private(set) var compositeRating: Int
    
    // MARK: - Initialization
    
    init(
        title: String,
        ratings: [Rating]
    ) {
        self.title = title
        self.ratings = ratings
        self.compositeRating = 1200
    }
    
    func update() {
        guard !ratings.isEmpty else { return }

        let weightedTotal = ratings.reduce(0.0) { partialResult, rating in
            partialResult + rating.value * Double(rating.dimension.weight)
        }

        let totalWeight = ratings.reduce(0) { partialResult, rating in
            partialResult + rating.dimension.weight
        }

        guard totalWeight > 0 else { return }

        compositeRating = Int(weightedTotal / Double(totalWeight))
    }
}
