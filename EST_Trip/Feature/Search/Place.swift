//
//  Place.swift
//  EST_Trip
//
//  Created by 권도현 on 6/11/25.
//


import Foundation


enum Category: String {
    case 관광, 맛집, 카페
}

struct Place {
    let imageName: String
    let title: String
    let subtitle: String
    let category: Category
}
