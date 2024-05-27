//
//  CloudkitManager.swift
//  TravelApp
//
//  Created by Agfi on 25/05/24.
//

import CloudKit
import Combine
import FirebaseAuth
import Foundation

class CloudKitManager: ObservableObject {
    private let container: CKContainer
    private let database: CKDatabase
    
    @Published var favoritePlacemarks: [Placemark] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        self.container = CKContainer.default()
        self.database = container.publicCloudDatabase
        self.fetchFavoritePlacemarks() // Fetch favorites on initialization
    }

    func saveFavoritePlacemark(placemark: Placemark) {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "User not authenticated"
            return
        }
        
        // Check if placemark already exists in favorites
        if isFavorite(placemark: placemark) {
            self.errorMessage = "Placemark already added to favorites"
            return
        }

        let record = placemark.toRecord()
        record["userID"] = user.uid as CKRecordValue
        
        isLoading = true
        database.save(record) { [weak self] savedRecord, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Failed to save favorite placemark: \(error.localizedDescription)"
                } else if let savedRecord = savedRecord {
                    let favorite = Placemark(record: savedRecord)
                    self?.favoritePlacemarks.append(favorite)
                }
            }
        }
    }

    func fetchFavoritePlacemarks() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "User not authenticated"
            return
        }
        
        let predicate = NSPredicate(format: "userID == %@", user.uid)
        let query = CKQuery(recordType: "Placemark", predicate: predicate)
        
        isLoading = true
        database.perform(query, inZoneWith: nil) { [weak self] records, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Failed to fetch favorite placemarks: \(error.localizedDescription)"
                } else if let records = records {
                    self?.favoritePlacemarks = records.map { Placemark(record: $0) }
                }
            }
        }
    }
    
    func deleteFavoritePlacemark(placemark: Placemark) {
        let recordID = placemark.id
        isLoading = true
        database.delete(withRecordID: recordID) { [weak self] deletedRecordID, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Failed to delete favorite placemark: \(error.localizedDescription)"
                } else {
                    self?.favoritePlacemarks.removeAll { $0.id == recordID }
                }
            }
        }
    }
    
    func isFavorite(placemark: Placemark) -> Bool {
        return favoritePlacemarks.contains(where: { $0.id == placemark.id })
    }
}

