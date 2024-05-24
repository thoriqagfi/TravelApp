//
//  ViewModel.swift
//  TravelApp
//
//  Created by Agfi on 17/05/24.
//

import Foundation
import MapKit

class ModelDataViewModel: ObservableObject {
    @Published var placemarks: [Placemark] = []
    @Published var tourismPackages: [TourismPackage] = []
    @Published var categories: [String] = []
    @Published var cities: [String] = []

    init() {
        loadPlacemarks()
        loadTourismPackages()
        updateCategoriesAndCities()
    }

    private func loadPlacemarks() {
        placemarks = load("placemarkData.json")
    }

    private func loadTourismPackages() {
        tourismPackages = load("tourismPackage.json")
    }

    private func updateCategoriesAndCities() {
        categories = Set(placemarks.map { $0.category }).sorted()
        cities = Set(placemarks.map { $0.city }).sorted()
    }

    func filterPlacemarks(by category: String?, and city: String?) -> [Placemark] {
        return placemarks.filter { placemark in
            (category == nil || placemark.category == category) &&
            (city == nil || placemark.city == city)
        }
    }

    func getClosestPlacemarks(to placemark: Placemark, count: Int = 5) -> [Placemark] {
        let currentLocation = CLLocation(latitude: placemark.lat, longitude: placemark.long)
        let sortedPlacemarks = placemarks.sorted {
            let location1 = CLLocation(latitude: $0.lat, longitude: $0.long)
            let location2 = CLLocation(latitude: $1.lat, longitude: $1.long)
            return currentLocation.distance(from: location1) < currentLocation.distance(from: location2)
        }
        return Array(sortedPlacemarks.prefix(count))
    }
    
    func load<T: Decodable>(_ fileName: String) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("Couldn't find \(fileName) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(fileName) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(fileName) as \(T.self):\n\(error)")
        }
    }
}
