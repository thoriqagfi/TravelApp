//
//  PlacemarkViewModel.swift
//  TravelApp
//
//  Created by Agfi on 17/05/24.
//

import SwiftUI
import Combine
import MapKit

class PlacemarkViewModel: ObservableObject {
    @Published var selectedPlacemark: Placemark?
    @Published var selectedCategory: String?
    @Published var selectedCity: String?
    @Published var showDetails: Bool = false
    @Published var route: MKRoute?
    @Published var mapSelection: MKMapItem?
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion())
    @Published var favoritePlacemarks: [Placemark] = []
    @Published var cameraRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    private var cancellables = Set<AnyCancellable>()
    private let geocoder = CLGeocoder()
    private let cloudKitManager = CloudKitManager()

    func saveFavoritePlacemark(placemark: Placemark) {
        cloudKitManager.saveFavoritePlacemark(placemark: placemark)
    }
    
    func fetchFavoritePlacemarks() {
        cloudKitManager.fetchFavoritePlacemarks()
    }
    
    var favoritePlacemarksPublisher: Published<[Placemark]>.Publisher {
        cloudKitManager.$favoritePlacemarks
    }
    
    var isLoadingPublisher: Published<Bool>.Publisher {
        cloudKitManager.$isLoading
    }
    
    var errorMessagePublisher: Published<String>.Publisher {
        cloudKitManager.$errorMessage
    }
    
    func updateCameraPosition(to placemark: Placemark) {
        let zoomOutRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: placemark.lat, longitude: placemark.long),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        
        let zoomInRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: placemark.lat, longitude: placemark.long),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        withAnimation(.easeInOut(duration: 0.8)) {
            self.cameraPosition = .region(zoomOutRegion)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.cameraPosition = .region(zoomInRegion)
            }
        }
    }
    
    func updateCameraPosition(to city: String) {
        geocoder.geocodeAddressString(city) { [weak self] (placemarks, error) in
            guard let self = self, error == nil else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
                )
                
                withAnimation(.easeInOut(duration: 1)) {
                    self.cameraPosition = .region(region)
                }
            }
        }
    }
    
    func distance(from: Placemark, to: Placemark) -> Double {
        let fromLocation = CLLocation(latitude: from.lat, longitude: from.long)
        let toLocation = CLLocation(latitude: to.lat, longitude: to.long)
        return fromLocation.distance(from: toLocation) / 1000 // convert to kilometers
    }
    
    func fetchRoute(placemark: Placemark?, locationService: LocationService) {
        guard let placemark = placemark else { return }
        
        let request = MKDirections.Request()
        request.source = .init(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: locationService.latitude, longitude: locationService.longitude)))
        request.destination = .init(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: placemark.lat, longitude: placemark.long)))
        
        let directions = MKDirections(request: request)
        directions.calculate { [self] response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            route = response.routes.first
        }
    }
    
    func fetchUnsplashImage(placemark: Placemark?, unsplashImageService: UnsplashImageService) {
        guard let placemark = placemark else {
            return
        }
        unsplashImageService.fetchImage(for: "\(placemark.name + placemark.city)")
    }
    
    func placemarksNearUserLocation(locationService: LocationService, radius: Double = 5.0, placemarks: [Placemark]) -> [Placemark] {
        return placemarks.filter { placemark in
            let userLocation = CLLocation(latitude: locationService.latitude, longitude: locationService.longitude)
            let placemarkLocation = CLLocation(latitude: placemark.lat, longitude: placemark.long)
            return userLocation.distance(from: placemarkLocation) <= radius * 1000 // radius in meters
        }
    }
    
    func recommendedPlacemarks(at city: String, placemarks: [Placemark]) -> [Placemark] {
        return placemarks.filter { $0.city == city }
            .sorted { $0.rating > $1.rating }
    }
    
    func distance(from: CLLocation, to: Placemark) -> Double {
        let toLocation = CLLocation(latitude: to.lat, longitude: to.long)
        return from.distance(from: toLocation) / 1000 // Convert to kilometers
    }
}
