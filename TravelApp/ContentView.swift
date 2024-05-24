//
//  ContentView.swift
//  TravelApp
//
//  Created by Agfi on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var modelDataViewModel = ModelDataViewModel()
    @StateObject var placemarkViewModel = PlacemarkViewModel()
    var body: some View {
        VStack {
            ContentNavigation(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel)
        }
    }
}

#Preview {
    ContentView()
}
