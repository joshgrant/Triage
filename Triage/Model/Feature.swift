//
//  Item.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

@Model
final class Feature {
    
    // MARK: - Properties
    
    var title: String
    var eloRank: Int
    var ratings: [Rating]
    var comparisonCount: Int
    
    // MARK: - Initialization
    
    init(
        title: String,
        eloRank: Int,
        ratings: [Rating]
    ) {
        self.title = title
        self.eloRank = eloRank
        self.ratings = ratings
        self.comparisonCount = 0
    }
}
