//
//  RecommendationsContentView.swift
//  TravelApp
//
//  Created by Agfi on 24/05/24.
//

import SwiftUI

struct RecommendationsContentView: View {
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    
    @StateObject private var cloudkitManager = CloudKitManager()
    @StateObject private var locationService = LocationService()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                FavoritePlacemarksView(placemarkViewModel: placemarkViewModel, cloudkitManager: cloudkitManager)
                NearPlacemarksView(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel, locationService: locationService)
                RecommendedPlacemarksView(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel, locationService: locationService)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding()
        }
        .onAppear {
            placemarkViewModel.fetchFavoritePlacemarks()
            cloudkitManager.fetchFavoritePlacemarks()
        }
        .onChange(of: cloudkitManager.favoritePlacemarks) {
            placemarkViewModel.fetchFavoritePlacemarks()
            cloudkitManager.fetchFavoritePlacemarks()
        }
    }
}

struct FavoritePlacemarksView: View {
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var cloudkitManager: CloudKitManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Placemark Favorites")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if cloudkitManager.favoritePlacemarks.isEmpty {
                ContentUnavailableView("Your Favorite Placemark is Empty", systemImage: "eye.slash")
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(cloudkitManager.favoritePlacemarks) { placemark in
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(placemark.name)
                                            .font(.headline)
                                        Text(placemark.city)
                                            .font(.subheadline)
                                    }
                                    Spacer(minLength: 5)
                                    Button(action: {
                                        cloudkitManager.deleteFavoritePlacemark(placemark: placemark)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .frame(width: 180, height: 60)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    placemarkViewModel.selectedPlacemark = placemark
                                    placemarkViewModel.showDetails.toggle()
                                }
                            }
                            .padding(5)
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct NearPlacemarksView: View {
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    @ObservedObject var locationService: LocationService
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Near from your location")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            let nearbyPlacemarks = placemarkViewModel.placemarksNearUserLocation(locationService: locationService, placemarks: modelDataViewModel.placemarks)
            
            // Sort nearbyPlacemarks by distance from the user's location
            let sortedPlacemarks = nearbyPlacemarks.sorted {
                guard let userLocation = locationService.location else { return false }
                let distance0 = placemarkViewModel.distance(from: userLocation, to: $0)
                let distance1 = placemarkViewModel.distance(from: userLocation, to: $1)
                return distance0 < distance1
            }
            
            if sortedPlacemarks.isEmpty {
                ContentUnavailableView("There is no Placemark near your location in 10 km", systemImage: "eye.slash")
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(sortedPlacemarks) { placemark in
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Text(placemark.name)
                                        .font(.headline)
                                    HStack(alignment: .center, spacing: 2) {
                                        Image(systemName: "mappin.circle.fill")
                                        Text(placemark.city)
                                            .font(.subheadline)
                                    }
                                    HStack(alignment: .center, spacing: 2) {
                                        if let userLocation = locationService.location {
                                            Image(systemName: "location.fill")
                                            Text("\(placemarkViewModel.distance(from: userLocation, to: placemark), specifier: "%.2f") km away")
                                                .font(.caption)
                                        }
                                    }
                                }
                                .frame(width: 180, height: 60)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    placemarkViewModel.selectedPlacemark = placemark
                                    placemarkViewModel.showDetails.toggle()
                                }
                            }
                            .padding(5)
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


struct RecommendedPlacemarksView: View {
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    @ObservedObject var locationService: LocationService
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recommendation at \(placemarkViewModel.selectedCity ?? "Your Selected City")")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            let recommendedPlacemarks = placemarkViewModel.recommendedPlacemarks(at: placemarkViewModel.selectedCity ?? "", placemarks: modelDataViewModel.placemarks)
            
            if recommendedPlacemarks.isEmpty {
                ContentUnavailableView("Select the City First", systemImage: "eye.slash")
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(recommendedPlacemarks) { placemark in
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(placemark.name)
                                            .font(.headline)
                                        Text(placemark.city)
                                            .font(.subheadline)
                                        HStack(alignment: .center, spacing: 8) {
                                            HStack(spacing: 2) {
                                                Image(systemName: "star.fill")
                                                Text("\(String(format: "%.1f", placemark.rating))")
                                                    .font(.caption)
                                            }
                                            HStack(alignment: .center, spacing: 2) {
                                                if let userLocation = locationService.location {
                                                    Image(systemName: "location.fill")
                                                    Text("\(placemarkViewModel.distance(from: userLocation, to: placemark), specifier: "%.2f") km away")
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(width: 180, height: 60)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    placemarkViewModel.selectedPlacemark = placemark
                                    placemarkViewModel.showDetails.toggle()
                                }
                            }
                            .padding(5)
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
