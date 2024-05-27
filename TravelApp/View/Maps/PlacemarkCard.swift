//
//  PlacemarkCard.swift
//  TravelApp
//
//  Created by Agfi on 24/05/24.
//

import SwiftUI

struct PlacemarkCard: View {
    let placemark: Placemark
    @Binding var isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, content: {
                Text(placemark.name)
                    .font(.headline)
                    .foregroundColor(isSelected ? .white : .blue)
                Spacer()
                Text(placemark.category)
                    .font(.subheadline)
                    .foregroundColor(isSelected ? .white : .gray)
            })
            HStack(alignment: .center, spacing: 16, content: {
                HStack(spacing: 2, content: {
                    Image(systemName: "location.fill")
                    Text(placemark.city)
                })
                HStack(spacing: 2, content: {
                    Image(systemName: "dollarsign.circle.fill")
                    Text("\(Int(placemark.price))")
                })
                HStack(spacing: 2, content: {
                    Image(systemName: "star.fill")
                    Text(String(format: "%.1f", placemark.rating))
                })
            })
            .foregroundColor(isSelected ? .white : .gray)
        }
        .padding()
        .background(isSelected ?
                    RoundedRectangle(cornerRadius: 10).fill(.blue) :
                        RoundedRectangle(cornerRadius: 10).fill(.white))
        .padding(.vertical, 4)
        .onTapGesture {
            isSelected.toggle()
        }
    }
}

#Preview {
    ContentView()
}
