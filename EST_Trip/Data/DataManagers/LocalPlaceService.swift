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
