//
//  CustomAnnotationView.swift
//  TravelApp
//
//  Created by Agfi on 19/05/24.
//

import SwiftUI

struct CustomAnnotationView: View {
    let placemark: Placemark
    let onTap: () -> Void

    var body: some View {
        VStack {
            annotationImage(for: placemark.category)
                .font(.title)
                .foregroundColor(color(for: placemark.category))
                .background(Color.white)
                .clipShape(Circle())
                .onTapGesture {
                    onTap()
                }
        }
    }

    @ViewBuilder
    private func annotationImage(for category: String) -> some View {
        switch category {
        case "Bahari":
            Image(systemName: "figure.pool.swim")
        case "Cagar Alam":
            Image(systemName: "leaf.circle.fill")
        case "Budaya":
            Image(systemName: "camera.circle.fill")
        case "Pusat Perbelanjaan":
            Image(systemName: "cart.fill")
        case "Taman Hiburan":
            Image(systemName: "figure.2.and.child.holdinghands")
        case "Tempat Ibadah":
            Image(systemName: "building.columns")
        default:
            Image(systemName: "mappin.circle.fill") // Default icon
        }
    }

    private func color(for category: String) -> Color {
        switch category {
        case "Bahari":
            return .blue
        case "Cagar Alam":
            return .green
        case "Budaya":
            return .purple
        case "Pusat Perbelanjaan":
            return .orange
        case "Taman Hiburan":
            return .pink
        case "Tempat Ibadah":
            return .yellow
        default:
            return .gray // Default color
        }
    }
}

