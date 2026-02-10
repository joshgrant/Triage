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
    
    var featureA: Feature
    var featureB: Feature
    
    var dimension: Dimension
    
    // Nil if skipped
    var selectedFeature: Feature?
    
    init(
        timestamp: Date,
        featureA: Feature,
        featureB: Feature,
        dimension: Dimension,
        selectedFeature: Feature? = nil
    ) {
        self.timestamp = timestamp
        self.featureA = featureA
        self.featureB = featureB
        self.dimension = dimension
        self.selectedFeature = selectedFeature
    }
}
