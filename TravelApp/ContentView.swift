//
//  ContentView.swift
//  TravelApp
//
//  Created by Agfi on 15/05/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = true
    
    @StateObject var modelDataViewModel = ModelDataViewModel()
    @StateObject var placemarkViewModel = PlacemarkViewModel()
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            if logStatus {
                ContentNavigation(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel)
            } else {
                AuthenticationView(authenticationViewModel: authenticationViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
