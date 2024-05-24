//
//  DetailCardView.swift
//  TravelApp
//
//  Created by Agfi on 24/05/24.
//

import SwiftUI

struct DetailCardView<Content: View>: View {
    let title: String
    let content: String
    let view: () -> Content
    
    var body: some View {
        ZStack(content: {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.semibold)
                    .font(.caption)
                view()
                Text(content)
                    .font(.caption)
                    .fontWeight(.light)
            }
            .padding()
        })
        .padding()
        .frame(height: 80)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(4.0)
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    ContentView()
}
