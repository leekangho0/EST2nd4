//
//  Place.swift
//  EST_Trip
//
//  Created by 권도현 on 6/11/25.
//


import UIKit
import GooglePlaces

// MARK: - Place Model

enum Category: String {
    case 관광, 맛집, 카페
}

struct Place {
    var imageName: String
    var title: String
    var subtitle: String
    var category: Category
    var placeID: String? = nil
    var thumbnailImage: UIImage? = nil
}

extension Place {
    init(gmsPlace: GMSPlace, category: Category = .관광) {
        self.imageName = "default"
        self.title = gmsPlace.name ?? "이름 없음"
        self.subtitle = "\(category.rawValue) · \(gmsPlace.formattedAddress ?? "주소 없음")"
        self.category = category
        self.placeID = gmsPlace.placeID      
    }
}
