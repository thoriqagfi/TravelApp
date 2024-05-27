//
//  MapDetails.swift
//  TravelApp
//
//  Created by Agfi on 17/05/24.
//

import SwiftUI
import MapKit

struct MapDetailsView: View {
    @StateObject private var locationService = LocationService()
    @StateObject private var unsplashImageService = UnsplashImageService()
    @StateObject private var cloudkitManager = CloudKitManager()
    @State private var isLoadingImage: Bool = false
    
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    
    @Binding var placemark: Placemark?
    @Binding var showDetails: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                imageSection
                descriptionSection
                recommendationsSection
                detailsSection
                Spacer()
                actionButtons
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(placemark?.name ?? "Detail Place")
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close") {
                        showDetails.toggle()
                    }
                    .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            .onAppear {
                placemarkViewModel.fetchUnsplashImage(placemark: placemark, unsplashImageService: unsplashImageService)
                unsplashImageService.fetchSomeImages(for: "\(placemark!.name + placemark!.city)", count: 4)
            }
            .onChange(of: placemarkViewModel.selectedPlacemark) {
                placemarkViewModel.fetchUnsplashImage(placemark: placemark, unsplashImageService: unsplashImageService)
                unsplashImageService.fetchSomeImages(for: "\(placemark!.name + placemark!.city)", count: 4)
            }
        }
    }
    
    private var imageSection: some View {
        ZStack {
            if isLoadingImage {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else if !unsplashImageService.images.isEmpty {
                TabView {
                        ForEach(unsplashImageService.images, id: \.self) { image in
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            } else {
                                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                                    .foregroundColor(.blue)
                                    .frame(width: 200, height: 200)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 200)
            } else {
                ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                    .foregroundColor(.blue)
                    .frame(height: 200)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var descriptionSection: some View {
        VStack {
            Text("Description")
                .multilineTextAlignment(.leading)
                .fontWeight(.semibold)
            Text(placemark?.description ?? "No Description")
                .font(.caption)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
        }
    }
    
    private var recommendationsSection: some View {
        VStack {
            Text("Recommendations Around \(placemark?.name ?? "")")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(modelDataViewModel.getClosestPlacemarks(to: placemark!).filter { $0.id != placemark?.id }) { nearbyPlacemark in
                        VStack(alignment: .leading) {
                            Text(nearbyPlacemark.name)
                                .font(.headline)
                            Text("\(nearbyPlacemark.city) - \(nearbyPlacemark.category)")
                                .font(.subheadline)
                            Text("\(String(format: "%.2f", placemarkViewModel.distance(from: placemark!, to: nearbyPlacemark))) km from \(placemark!.name)")
                                .font(.footnote)
                        }
//                        .frame(width: 200)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .onTapGesture {
                            self.placemark = nearbyPlacemark
                        }
                    }
                }
            }
        }
    }
    
    private var detailsSection: some View {
        VStack {
            Text("Details")
                .multilineTextAlignment(.leading)
                .fontWeight(.semibold)
            HStack {
                DetailCardView(title: "Rating", content: "\(String(format: "%.1f", placemark?.rating ?? 0.0)) / 5.0") {
                    StarRatingView(rating: placemark?.rating ?? 0.0)
                }
                DetailCardView(title: "City", content: "") {
                    HStack(spacing: 2) {
                        Image(systemName: "location.fill")
                            .fontWeight(.bold)
                        Text(placemark?.city ?? "No City Found")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.blue)
                }
                DetailCardView(title: "Price", content: "") {
                    HStack(spacing: 2) {
                        Image(systemName: "dollarsign.square.fill")
                            .fontWeight(.bold)
                        Text("Rp\(String(format: "%.0f", placemark?.price ?? 0.0))")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
    
    private var actionButtons: some View {
        HStack {
            if cloudkitManager.isFavorite(placemark: placemark!) {
                Button(action: {
                    cloudkitManager.deleteFavoritePlacemark(placemark: placemark!)
                    showDetails.toggle()
                }) {
                    Label("Remove from Favorites", systemImage: "minus.circle.fill")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.red)
                .cornerRadius(12.0)
            } else {
                Button(action: {
                    cloudkitManager.saveFavoritePlacemark(placemark: placemark!)
                    showDetails.toggle()
                }) {
                    Label("Add to Favorites", systemImage: "plus.circle.fill")
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.18, green: 0.25, blue: 0.35))
                .cornerRadius(12.0)
            }
            
            Button(action: {
                placemarkViewModel.fetchRoute(placemark: placemark, locationService: locationService)
                showDetails.toggle()
            }) {
                Label("Get Directions", systemImage: "play.fill")
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.blue)
            .cornerRadius(12.0)
        }
    }
}

#Preview {
    ContentView()
}
