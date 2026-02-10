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
        let total = ratings.reduce(0) { partialResult, rating in
            partialResult + rating.value
        }
        
        compositeRating = Int(total) / ratings.count
    }
}
