//
//  Placemark.swift
//  TravelApp
//
//  Created by Agfi on 16/05/24.
//P

import CloudKit
import Foundation

struct Placemark: Codable, Identifiable, Equatable {
    let id: CKRecord.ID
    let place_id: Int
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
        case id
        case place_id = "Place_Id"
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

    init(id: CKRecord.ID = CKRecord.ID(), place_id: Int, name: String, description: String, category: String, city: String, price: Double, rating: Double, timeMinutes: Int, coordinate: String, lat: Double, long: Double) {
        self.id = id
        self.place_id = place_id
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

    init(record: CKRecord) {
        self.id = record.recordID
        self.place_id = record["place_id"] as? Int ?? 0
        self.name = record["name"] as? String ?? ""
        self.description = record["description"] as? String ?? ""
        self.category = record["category"] as? String ?? ""
        self.city = record["city"] as? String ?? ""
        self.price = record["price"] as? Double ?? 0.0
        self.rating = record["rating"] as? Double ?? 0.0
        self.timeMinutes = record["timeMinutes"] as? Int ?? 0
        self.coordinate = record["coordinate"] as? String ?? ""
        self.lat = record["lat"] as? Double ?? 0.0
        self.long = record["long"] as? Double ?? 0.0
    }

    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: "Placemark", recordID: id)
        record["place_id"] = place_id as CKRecordValue
        record["name"] = name as CKRecordValue
        record["description"] = description as CKRecordValue
        record["category"] = category as CKRecordValue
        record["city"] = city as CKRecordValue
        record["price"] = price as CKRecordValue
        record["rating"] = rating as CKRecordValue
        record["timeMinutes"] = timeMinutes as CKRecordValue
        record["coordinate"] = coordinate as CKRecordValue
        record["lat"] = lat as CKRecordValue
        record["long"] = long as CKRecordValue
        return record
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // When decoding from JSON, generate a new CKRecord.ID
        self.id = CKRecord.ID()
        self.place_id = try container.decode(Int.self, forKey: .place_id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(String.self, forKey: .category)
        self.city = try container.decode(String.self, forKey: .city)
        self.price = try container.decode(Double.self, forKey: .price)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.timeMinutes = try container.decode(Int.self, forKey: .timeMinutes)
        self.coordinate = try container.decode(String.self, forKey: .coordinate)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.long = try container.decode(Double.self, forKey: .long)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.recordName, forKey: .id)
        try container.encode(place_id, forKey: .place_id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(city, forKey: .city)
        try container.encode(price, forKey: .price)
        try container.encode(rating, forKey: .rating)
        try container.encode(timeMinutes, forKey: .timeMinutes)
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(lat, forKey: .lat)
        try container.encode(long, forKey: .long)
    }
}

