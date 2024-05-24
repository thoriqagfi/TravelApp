//
//  TourismPackage.swift
//  TravelApp
//
//  Created by Agfi on 22/05/24.
//

import Foundation

struct TourismPackage: Codable, Equatable, Identifiable {
    let id: Int
    let city: String
    let place_tourism1: String
    let place_tourism2: String
    let place_tourism3: String
    let place_tourism4: String
    let place_tourism5: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Package"
        case city = "City"
        case place_tourism1 = "Place_Tourism1"
        case place_tourism2 = "Place_Tourism2"
        case place_tourism3 = "Place_Tourism3"
        case place_tourism4 = "Place_Tourism4"
        case place_tourism5 = "Place_Tourism5"
    }
    
    init(id: Int, city: String, place_tourism1: String, place_tourism2: String, place_tourism3: String, place_tourism4: String, place_tourism5: String) {
        self.id = id
        self.city = city
        self.place_tourism1 = place_tourism1
        self.place_tourism2 = place_tourism2
        self.place_tourism3 = place_tourism3
        self.place_tourism4 = place_tourism4
        self.place_tourism5 = place_tourism5
    }
}
