//
//  PlacemarkList.swift
//  TravelApp
//
//  Created by Agfi on 17/05/24.
//

import SwiftUI

struct PlacemarkList: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.placemarks) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                }
            }
            .navigationTitle("Items")
        }
    }
}

#Preview {
    PlacemarkList()
        .environmentObject(PlacemarkViewModel())
}
