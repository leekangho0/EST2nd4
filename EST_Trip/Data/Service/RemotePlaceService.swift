//
//  RemotePlaceService.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import Foundation
import GooglePlacesSwift
import CoreLocation
import GooglePlaces

enum Jeju {
    case northEast
    case southWest
    
    var coordinate2d: CLLocationCoordinate2D {
        switch self {
        case .northEast:
            return .init(latitude: 33.1127, longitude: 126.0843)
        case .southWest:
            return .init(latitude: 33.3350, longitude: 126.5820)
        }
    }
}

final class RemotePlaceService {
    struct SearchPlace {
        let id: String
        let displayName: AttributedString
        let distance: String
    }
    
    @MainActor
    let client = PlacesClient.shared
    
    enum Filter {
        static let defaultProperties: [PlaceProperty] = [.displayName, .placeID, .photos, .coordinate, .formattedAddress, .numberOfUserRatings, .rating, .types]
        static let country = "KR"
    }
    
    func autoComplete(text: String, category: CategoryType? = nil, center: (Double, Double)) async throws -> [AutocompleteSuggestion] {
        let bound = RectangularCoordinateRegion(northEast: Jeju.northEast.coordinate2d, southWest: Jeju.southWest.coordinate2d)!
        let filter = AutocompleteFilter(
            types: Set(category?.list() ?? []),
            countries: [Filter.country],
            coordinateRegionRestriction: bound,
            regionCode: Filter.country
        )
        
        let request = AutocompleteRequest(
            query: text,
            sessionToken: nil,
            filter: filter,
            inputOffset: 0)
        let result = await client.fetchAutocompleteSuggestions(with: request)
        
        switch result {
        case let .success(suggestions):
            return suggestions
        case let .failure(error):
            throw error
        }
    }
    
    func fetchPlace(by id: String) async throws -> Place {
        let request = FetchPlaceRequest(placeID: id, placeProperties: [.displayName, .placeID, .photos, .coordinate, .formattedAddress, .numberOfUserRatings, .rating, .types])
        
        let result = await client.fetchPlace(with: request)
        
        switch result {
        case .success(let place):
            
            return place
        case .failure(let error):
            throw error
        }
    }
    
    func fetch(by photo: Photo) async throws -> UIImage {
        let request = FetchPhotoRequest(photo: photo, maxSize: CGSize(width: 300, height: 300))
        switch await client.fetchPhoto(with: request) {
        case let .success(image):
            return image
        case let .failure(error):
            throw error
        }
    }
    
    func fetch(by text: String, category: CategoryType?) async throws -> [Place] {
//        let bound = RectangularCoordinateRegion(northEast: Jeju.northEast.coordinate2d, southWest: Jeju.southWest.coordinate2d)!
//        
        let center = CircularCoordinateRegion(center: Jeju.northEast.coordinate2d, radius: 600)
        let request = SearchByTextRequest(
            textQuery: text,
            placeProperties: Filter.defaultProperties,
            locationBias: center, // 변경
            includedType: category?.single(),
            maxResultCount: 10, minRating: 2.5,
            rankPreference: .distance,
            regionCode: Filter.country,
            isStrictTypeFiltering: false)
        
        switch await client.searchByText(with: request) {
        case let .success(places):
            return places
        case let .failure(error):
            throw error
        }
    }
    
    func fetchNearBy() async throws -> [Place] {
        let center = CircularCoordinateRegion(center: Jeju.northEast.coordinate2d, radius: 600)
        
        let request = SearchNearbyRequest(
            locationRestriction: center,
            placeProperties: Filter.defaultProperties,
            includedTypes: [.cafe],
            maxResultCount: 10,
            rankPreference: .popularity,
            regionCode: Filter.country
        )
        
        switch await client.searchNearby(with: request) {
        case let .success(places):
            return places
        case let .failure(error):
            throw error
        }
    }
}

extension CategoryType {
    func single() -> PlaceType? {
        switch self {
        case .accmodation:
            return .lodging
        case .cafe:
            return .cafe
        case .restaurant:
            return .restaurant
        case .transportation:
            return .transitStation
        case .travel:
            return .touristAttraction
        case .shopping:
            return .shoppingMall
        case .etc:
            return nil
        }
    }
    
    func list() -> [PlaceType] {
        switch self {
        case .accmodation:
            return [.lodging]
        case .cafe:
            return [.cafe, .bakery]
        case .restaurant:
            return [.restaurant, .mealTakeaway, .mealDelivery]
        case .transportation:
            return [.busStation, .subwayStation, .trainStation, .transitStation, .airport, .taxiStand]
        case .travel:
            return [
                .touristAttraction, .pointOfInterest, .naturalFeature, .park
            ]
        case .shopping:
            return [
                .shoppingMall, .clothingStore, .departmentStore, .store, .supermarket, .convenienceStore
            ]
        case .etc:
            return []
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
