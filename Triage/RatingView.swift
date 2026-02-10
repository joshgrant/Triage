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
    
    private var ratingLabel: String {
        if rating.value > 0 {
            "+\(rating.value)"
        } else {
            "\(rating.value)"
        }
    }
    
    private var ratingColor: Color {
        if rating.value > 0 {
            return .green
        } else {
            return .red
        }
    }
}

#Preview {
    let dimension = Dimension(
        label: "Astrorelevance",
        explanation: "How relevant is this to space travel?",
        weight: 3)
    
    let rating = Rating(
        value: 31,
        dimension: dimension
    )
    
    RatingView(rating: rating)
}
