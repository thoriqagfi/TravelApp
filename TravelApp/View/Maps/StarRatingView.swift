//
//  StarRatingView.swift
//  TravelApp
//
//  Created by Agfi on 22/05/24.
//

import SwiftUI

struct StarRatingView: View {
    var rating: Double
    private let maxRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maxRating, id: \.self) { index in
                if index < Int(rating) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                } else if index == Int(rating), rating.truncatingRemainder(dividingBy: 1) >= 0.5 {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundColor(.yellow)
                        .font(.caption)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    StarRatingView(rating: 4.5)
}
