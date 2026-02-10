//
//  History.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

@Model
final class History {

    var timestamp: Date

    var featureA: Feature?
    var featureB: Feature?

    var dimension: Dimension

    // Nil if skipped or tied
    var selectedFeature: Feature?

    // True if the user chose to skip (no opinion), as opposed to a tie (equal)
    var skipped: Bool

    init(
        timestamp: Date,
        featureA: Feature,
        featureB: Feature,
        dimension: Dimension,
        selectedFeature: Feature? = nil,
        skipped: Bool = false
    ) {
        self.timestamp = timestamp
        self.featureA = featureA
        self.featureB = featureB
        self.dimension = dimension
        self.selectedFeature = selectedFeature
        self.skipped = skipped
    }
}
