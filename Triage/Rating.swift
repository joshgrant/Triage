//
//  Rating.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

/// A rating is a derived value taken from the
@Model
final class Rating {
    
    // MARK: - Properties
    
    var value: Int
    var dimension: Dimension
    
    // MARK: - Initialization
    
    init(
        value: Int,
        dimension: Dimension
    ) {
        self.value = value
        self.dimension = dimension
    }
}
