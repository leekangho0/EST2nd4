//
//  GMSMarker+Util.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import Foundation
import GoogleMaps

extension GMSMarker {
    static func make(from place: PlaceDTO) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longittude)
        marker.title = place.name
        marker.snippet = place.category.name
        marker.icon = place.category.image
        
        return marker
    }
}
