//
//  Ranking.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation

func pickPair(features: [Feature], history: [History]) -> (a: Feature, b: Feature)? {
    guard features.count >= 2 else {
        return nil
    }
    
    var featureComparisonCount: [Feature: Int] = Dictionary(uniqueKeysWithValues: features.map({ ($0, 0) }))
    
    for pair in history {
        featureComparisonCount[pair.featureA, default: 0] += 1
        featureComparisonCount[pair.featureB, default: 0] += 1
    }
    
    let featuresSorted = featureComparisonCount.sorted { a, b in
        a.value < b.value
    }
    
    let a = featuresSorted[0].key
    let b = featuresSorted[1].key
    
    return (a, b)
}
