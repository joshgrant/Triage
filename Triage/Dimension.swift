//
//  Dimension.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import Foundation
import SwiftData

@Model
final class Dimension {
    
    #Unique<Dimension>([\.label])
    
    var label: String
    var explanation: String
    var weight: Int
    
    init(
        label: String,
        explanation: String,
        weight: Int
    ) {
        self.label = label
        self.explanation = explanation
        self.weight = weight
    }
}
