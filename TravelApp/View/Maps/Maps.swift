//
//  Maps.swift
//  TravelApp
//
//  Created by Agfi on 18/05/24.
//

import SwiftUI
import MapKit

struct Maps: View {
    @ObservedObject var modelDataViewModel: ModelDataViewModel
    @ObservedObject var placemarkViewModel: PlacemarkViewModel
    @StateObject private var locationService = LocationService()
    
    @Namespace private var locationSpace
    @State private var viewingRegion: MKCoordinateRegion?
    
    var body: some View {
        Map(position: $placemarkViewModel.cameraPosition, selection: $placemarkViewModel.mapSelection, scope: locationSpace) {
            Annotation(
                "Your Location",
                coordinate: CLLocationCoordinate2D(latitude: locationService.latitude, longitude: locationService.longitude),
                content: {
                    UserAnnotationCircle()
                })
            UserAnnotation()
            
            ForEach(modelDataViewModel.filterPlacemarks(by: placemarkViewModel.selectedCategory, and: placemarkViewModel.selectedCity)) { placemark in
                Annotation(placemark.name, coordinate: CLLocationCoordinate2DMake(placemark.lat, placemark.long), content: {
                    CustomAnnotationView(placemark: placemark, onTap: {
                        placemarkViewModel.showDetails.toggle()
                        placemarkViewModel.selectedPlacemark = placemark
                    })
                })
            }
            
            if let route = placemarkViewModel.route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .onChange(of: placemarkViewModel.selectedPlacemark) { newPlacemark in
            if let placemark = newPlacemark {
                withAnimation {
                    placemarkViewModel.updateCameraPosition(to: placemark)
                }
            }
        }
        .onChange(of: placemarkViewModel.selectedCity) { newCity in
            if let city = newCity {
                placemarkViewModel.updateCameraPosition(to: city)
            }
        }
        .onMapCameraChange { ctx in
            viewingRegion = ctx.region
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 15, content: {
                MapCompass(scope: locationSpace)
                MapPitchToggle(scope: locationSpace)
                MapUserLocationButton(scope: locationSpace)
            })
            .buttonBorderShape(.circle)
            .padding()
        }
        .overlay(alignment: .bottom, content: {
            if placemarkViewModel.route != nil {
                Button("End Route") {
                    placemarkViewModel.route = nil
                }
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(.red)
                .padding()
                .cornerRadius(8.0)
            }
        })
        .mapScope(locationSpace)
        .navigationBarTitleDisplayMode(.inline)
        // Showing Translucent Toolbar
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .sheet(isPresented: $placemarkViewModel.showDetails, content: {
            MapDetails($placemarkViewModel.selectedPlacemark)
                .presentationDetents([.height(300)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                .presentationCornerRadius(25)
                .interactiveDismissDisabled(true)
        })
    }
    
    @ViewBuilder
    func MapDetails(_ placemark: Binding<Placemark?>) -> some View {
        VStack(spacing: 15, content: {
            MapDetailsView(placemarkViewModel: placemarkViewModel, modelDataViewModel: modelDataViewModel, placemark: placemark, showDetails: $placemarkViewModel.showDetails)
                .multilineTextAlignment(.leading)
        })
    }
}

#Preview {
    ContentView()
}
