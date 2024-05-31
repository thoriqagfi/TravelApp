//
//  SiderbarMapsView.swift
//  TravelApp
//
//  Created by Agfi on 21/05/24.
//

import SwiftUI
import Firebase

struct SiderbarMapsView: View {
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    
    @AppStorage("log_Status") private var logStatus: Bool = false
    
    var body: some View {
        NavigationSplitView(sidebar: {
            NavigationStack {
                HStack {
                    Picker("Category", selection: $placemarkViewModel.selectedCategory) {
                        Text("All").tag(String?.none)
                        ForEach(modelDataViewModel.categories, id: \.self) { category in
                            Text(category).tag(String?.some(category))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("City", selection: $placemarkViewModel.selectedCity) {
                        Text("All").tag(String?.none)
                        ForEach(modelDataViewModel.cities, id: \.self) { city in
                            Text(city).tag(String?.some(city))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(modelDataViewModel.filterPlacemarks(by: placemarkViewModel.selectedCategory, and: placemarkViewModel.selectedCity)) { placemark in
                            PlacemarkCard(placemark: placemark, isSelected: Binding<Bool>(
                                get: { placemarkViewModel.selectedPlacemark == placemark },
                                set: { isSelected in
                                    if isSelected {
                                        placemarkViewModel.selectedPlacemark = placemark
                                    } else {
                                        placemarkViewModel.selectedPlacemark = nil
                                    }
                                }
                            ))
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("Destination")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                .shadow(color: Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.36), radius: 0, x: 0.5, y: 0)
            }
        }, detail: {
            NavigationStack {
                Maps(modelDataViewModel: modelDataViewModel, placemarkViewModel: placemarkViewModel)
                    .navigationTitle(placemarkViewModel.selectedPlacemark?.name ?? "Maps")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Sign Out") {
                                try? Auth.auth().signOut()
                                logStatus = false
                            }
                            .foregroundStyle(.red)
                        }
                    }
            }
        })
    }
}

#Preview {
    ContentView()
}
