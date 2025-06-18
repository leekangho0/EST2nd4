//
//  GooglePlaceDTO.swift
//  EST_Trip
//
//  Created by kangho lee on 6/18/25.
//

import UIKit
import GooglePlacesSwift

struct GooglePlaceDTO {
    let place: Place
    var image: UIImage?
}

extension GooglePlaceDTO {
    func apply(_ entity: PlaceEntity) {
        entity.latitude = place.location.latitude
        entity.longitude = place.location.longitude
        entity.name = place.displayName
        entity.reviewCount = Int16(place.numberOfUserRatings)
        entity.rating = Double(place.rating ?? 0.0)
        entity.photo = image?.jpegData(compressionQuality: 1)
        entity.categoryType = CategoryType.from(placeTypes: place.types.map(\.rawValue))
        entity.address = place.formattedAddress
        entity.id = UUID(uuidString: place.placeID ?? UUID().uuidString) ?? UUID()
    }
}
