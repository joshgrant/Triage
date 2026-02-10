//
//  RatingView.swift
//  Triage
//
//  Created by Joshua Grant on 2/10/26.
//

import SwiftUI

struct RatingView: View {
    
    var rating: Rating
    
    var body: some View {
        Text("\(dimensionLabel) \(ratingLabel)")
            .font(.caption.bold())
            .foregroundStyle(ratingColor)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(ratingColor.quaternary)
            .clipShape(.capsule)
    }
    
    private var dimensionLabel: String {
        rating.dimension.label.prefix(3).uppercased()
    }
    
    private var displayedValue: Int {
        Int(rating.value - 1200)
    }
    
    private var ratingLabel: String {
        if displayedValue > 0 {
            return "+\(displayedValue)"
        } else {
            return displayedValue.formatted()
        }
    }
    
    private var ratingColor: Color {
        if displayedValue > 0 {
            return .green
        } else if displayedValue < 0 {
            return .red
        } else {
            return .gray
        }
    }
}

#Preview {
    let dimension = Dimension(
        label: "Astrorelevance",
        explanation: "How relevant is this to space travel?",
        weight: 3)
    
    let rating = Rating(
        value: 1194,
        dimension: dimension
    )
    
    RatingView(rating: rating)
}
