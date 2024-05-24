//
//  Placemark.swift
//  TravelApp
//
//  Created by Agfi on 16/05/24.
//P

import Foundation

struct Placemark: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let category: String
    let city: String
    let price: Double
    let rating: Double
    let timeMinutes: Int
    let coordinate: String
    let lat: Double
    let long: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "Place_Id"
        case name = "Place_Name"
        case description = "Description"
        case category = "Category"
        case city = "City"
        case price = "Price"
        case rating = "Rating"
        case timeMinutes = "Time_Minutes"
        case coordinate = "Coordinate"
        case lat = "Lat"
        case long = "Long"
    }
    
    init(id: Int, name: String, description: String, category: String, city: String, price: Double, rating: Double, timeMinutes: Int, coordinate: String, lat: Double, long: Double) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.city = city
        self.price = price
        self.rating = rating
        self.timeMinutes = timeMinutes
        self.coordinate = coordinate
        self.lat = lat
        self.long = long
    }
}
