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
            entity.scheduleID = UUID()
            entity.address = place.formattedAddress
            entity.latitude = place.coordinate.latitude
            entity.longitude = place.coordinate.longitude
            entity.category = CategoryType.from(placeTypes: place.types ?? [] ).rawValue
        }
    }
    
    
    func fetchByCoordinate(latitude: Double, longitude: Double, tolerance: Double = 0.0001) -> PlaceEntity? {
            let latPredicate = NSPredicate(format: "ABS(latitude - %f) < %f", latitude, tolerance)
            let lonPredicate = NSPredicate(format: "ABS(longitude - %f) < %f", longitude, tolerance)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latPredicate, lonPredicate])

            let result: [PlaceEntity] = CoreDataManager.shared.fetch(PlaceEntity.self, predicate: predicate)
            return result.first
        }

    func fetchByName(_ name: String) -> [PlaceEntity] {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", name)
            return CoreDataManager.shared.fetch(PlaceEntity.self, predicate: predicate)
        }
    
    func remove(place: PlaceEntity) {
        CoreDataManager.shared.delete(place)
    }
}




extension CategoryType {
    static func from(placeTypes: [String]) -> CategoryType {
           for type in placeTypes {
               switch type {
               case "lodging":
                   return .accmodation
               case "cafe", "bakery":
                   return .cafe
               case "restaurant", "meal_takeaway", "meal_delivery":
                   return .restaurant
               case "bus_station", "subway_station", "train_station", "transit_station", "airport", "taxi_stand":
                   return .transportation
               case "tourist_attraction", "point_of_interest", "natural_feature", "park":
                   return .travel
               case "shopping_mall", "clothing_store", "department_store", "store", "supermarket", "convenience_store":
                   return .shopping
               default:
                   continue
               }
           }
           return .etc
       }
}
