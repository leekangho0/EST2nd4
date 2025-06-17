//
//  LocalPlaceService.swift
//  EST_Trip
//
//  Created by 권도현 on 6/12/25.
//

import Foundation
import CoreData
import CoreLocation
import GooglePlaces


class LocalPlaceService {
    static let shared = LocalPlaceService()
    private init() {}
    
    
    func addPlace(place: GMSPlace) {
        CoreDataManager.shared.insert(PlaceEntity.self) { entity in
            entity.name = place.name
            entity.id = UUID()
//            entity.scheduleID = UUID()
            entity.address = place.formattedAddress
            entity.latitude = place.coordinate.latitude
            entity.longitude = place.coordinate.longitude
            entity.category = CategoryType.from(placeTypes: place.types ?? [] ).rawValue
        }
    }
    
    
    func fetchByCoordinate(latitude: Double, longitude: Double, tolerance: Double = 0.0001) -> TravelEntity? {
            let latPredicate = NSPredicate(format: "ABS(latitude - %f) < %f", latitude, tolerance)
            let lonPredicate = NSPredicate(format: "ABS(longitude - %f) < %f", longitude, tolerance)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latPredicate, lonPredicate])

            let result: [TravelEntity] = CoreDataManager.shared.fetch(TravelEntity.self, predicate: predicate)
            return result.first
        }

    func fetchByName(_ name: String) -> [TravelEntity] {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", name)
            return CoreDataManager.shared.fetch(TravelEntity.self, predicate: predicate)
        }
    
    func remove(place: TravelEntity) {
        CoreDataManager.shared.delete(place)
    }
}
