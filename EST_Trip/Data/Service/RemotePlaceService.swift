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
//
//final class RemotePlaceService {
//    struct SearchPlace {
//        let id: String
//        let displayName: AttributedString
//        let distance: String
//    }
//    
//    @MainActor
//    static let client = PlacesClient.shared
//    
//    func nearBySearch(coordinate: CLLocationCoordinate2D, radius: Double) {
//        
//    }
//    
//    func fetchPhoto(id: String) {
//        
//    }
//    
//    func textSearch(_ text: String, latitude: Double, longitude: Double, radius: Double) {
//        let restriction = CircularCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius: radius)
//        
//        let searchByTextRequest = SearchByTextRequest(
//            textQuery: "pizza in New York",
//            placeProperties: [ .name, .placeID ],
//            locationRestriction: restriction,
//            includedType: .restaurant,
//            maxResultCount: 5,
//            minRating: 3.5,
//            priceLevels: [ .moderate, .inexpensive ],
//            isStrictTypeFiltering: true
//        )
//    }
//    
//    func textSearch(_ text: String, radius: Double) {
//        
//        let restriction = RectangularCoordinateRegion(
//            northEast: Jeju.northEast.coordinate2d,
//            southWest: Jeju.southWest.coordinate2d
//        )
//        
//        let searchByTextRequest = SearchByTextRequest(
//            textQuery: text,
//            placeProperties: [ .name, .placeID ],
//            locationRestriction: restriction,
//            includedType: .restaurant,
//            maxResultCount: 5,
//            minRating: 3.5,
//            priceLevels: [ .moderate, .inexpensive ],
//            isStrictTypeFiltering: true
//        )
//        
//        //        switch await placesClient.searchByText(with: searchByTextRequest) {
//        //        case .success(let places):
//        //          // Handle places
//        //        case .failure(let placesError):
//        //          // Handle error
//        //        }
//    }
//    
//    func autoComplete(_ text: String, latitude: Double, longitude: Double, radius: Double) async throws -> [SearchPlace] {
//        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let restriction = CircularCoordinateRegion(center: center, radius: radius)
//        let filter = AutocompleteFilter(coordinateRegionRestriction: restriction)
//        let request = AutocompleteRequest(query: text, sessionToken: nil, filter: filter)
//        
//        var searchPlace: [SearchPlace] = []
//        switch await PlacesClient.shared.fetchAutocompleteSuggestions(with: request) {
//        case .success(let suggestions):
//            for suggestion in suggestions {
//                switch suggestion {
//                case .place(let data):
//                    searchPlace.append(
//                        SearchPlace(
//                            id: data.placeID,
//                            displayName: data.attributedFullText,
//                            distance: data.distance?.description ?? "unknown"
//                        )
//                    )
//                @unknown default:
//                    fatalError()
//                }
//            }
//        case .failure(let error):
//            throw error
//        }
//    }
//}
