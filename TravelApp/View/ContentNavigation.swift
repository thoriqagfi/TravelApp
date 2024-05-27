//
//  ContentNavigation.swift
//  TravelApp
//
//  Created by Agfi on 19/05/24.
//

import SwiftUI
import MapKit

struct ContentNavigation: View {
    @State private var selection: Tab = .maps
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    
    enum Tab {
        case maps
        case list
    }
    var body: some View {
        TabView(selection: $selection, content: {
            SiderbarMapsView(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel)
                .tabItem {
                    Label("Maps", systemImage: "map.fill")
                        .foregroundStyle(.blue)
                }
            .tag(Tab.maps)
            .onChange(of: placemarkViewModel.mapSelection, { oldValue, newValue in
                placemarkViewModel.showDetails = newValue != nil
            })
            
            RecommendationsContentView(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel)
                .tabItem {
                    Label("Recommendations", systemImage: "mappin")
                        .foregroundStyle(.blue)
                }
                .tag(Tab.list)
        })
    }
}

#Preview {
    ContentView()
}
