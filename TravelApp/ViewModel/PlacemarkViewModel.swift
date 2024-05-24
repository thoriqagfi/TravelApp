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

    @EnvironmentObject var modelData: ModelDataViewModel
    @Published var cameraRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    private var cancellables = Set<AnyCancellable>()
    private let geocoder = CLGeocoder()

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
            print("Placemark is nil.")
            return
        }
        unsplashImageService.fetchImage(for: "\(placemark.name + placemark.city)")
    }
}
