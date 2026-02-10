//
//  Rating.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

/// A rating is an Elo rank for a feature along a given dimension
@Model
final class Rating {
    
    // MARK: - Properties
    
    var value: Double
    var dimension: Dimension
    
    // MARK: - Initialization
    
    init(
        value: Double,
        dimension: Dimension
    ) {
        self.value = value
        self.dimension = dimension
    }
}
