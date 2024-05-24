//
//  UserAnnotationCircle.swift
//  TravelApp
//
//  Created by Agfi on 17/05/24.
//

import SwiftUI
import MapKit

struct UserAnnotationCircle: View {
    var body: some View {
        ZStack(content: {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(.blue.opacity(0.25))
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Circle()
                .frame(width: 12, height: 12)
                .foregroundColor(.blue)
        })
    }
}

#Preview {
    UserAnnotationCircle()
}
