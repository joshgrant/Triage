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
    
    // MARK: - Initialization
    
    init(
        title: String,
        eloRank: Int
    ) {
        self.title = title
        self.eloRank = eloRank
    }
}
