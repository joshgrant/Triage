//
//  Triage.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

struct FeaturePair: Hashable {
    let a: Feature
    let b: Feature

    init(_ a: Feature, _ b: Feature) {
        // Normalize ordering so (A,B) and (B,A) are the same pair
        if a.persistentModelID.hashValue <= b.persistentModelID.hashValue {
            self.a = a
            self.b = b
        } else {
            self.a = b
            self.b = a
        }
    }
}

func pickPair(features: [Feature], history: [History]) -> (a: Feature, b: Feature)? {
    guard features.count >= 2 else {
        return nil
    }

    // Count how many times each specific pair has been compared.
    // Each comparison session produces one History entry per dimension,
    // so we count unique sessions (dividing by dimensions would be fragile;
    // instead we just find the pair with the fewest total entries).
    var pairCounts: [FeaturePair: Int] = [:]

    // Initialize all possible pairs to 0
    for i in 0 ..< features.count {
        for j in (i + 1) ..< features.count {
            let pair = FeaturePair(features[i], features[j])
            pairCounts[pair] = 0
        }
    }

    for entry in history {
        // Only count if both features still exist in the current list
        guard let entryA = entry.featureA,
              let entryB = entry.featureB,
              features.contains(where: { $0 == entryA }),
              features.contains(where: { $0 == entryB }) else {
            continue
        }
        let pair = FeaturePair(entryA, entryB)
        pairCounts[pair, default: 0] += 1
    }

    // Pick the pair with the fewest comparisons
    guard let leastCompared = pairCounts.min(by: { $0.value < $1.value }) else {
        return nil
    }

    return (a: leastCompared.key.a, b: leastCompared.key.b)
}
