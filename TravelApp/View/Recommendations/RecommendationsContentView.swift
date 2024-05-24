//
//  RecommendationsContentView.swift
//  TravelApp
//
//  Created by Agfi on 24/05/24.
//

import SwiftUI

struct RecommendationsContentView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Placemark Favorites")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Near from your location")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Recommendation at City")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
            .navigationTitle("Recommendation Place")
        }
    }
}

#Preview {
    RecommendationsContentView()
}
