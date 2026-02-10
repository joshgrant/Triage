//
//  Ranking.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation

func pickPair(features: [Feature]) -> (a: Feature, b: Feature)? {
    guard features.count >= 2 else {
        return nil
    }
    
    // The feature with the fewest comparisons will be first
    let featuresByComparisons: [Feature] = features.sorted { a, b in
        a.comparisonCount < b.comparisonCount
    }
    
    let a = featuresByComparisons[0]
    let b = featuresByComparisons[1]
    
    return (a, b)
}
