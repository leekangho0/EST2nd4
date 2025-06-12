//
//  Transport.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/12/25.
//

import Foundation

enum Transport: Int, CaseIterable {
    case car, transit, walk
    
    var image: String {
        switch self {
        case .car:
            return "car.fill"
        case .transit:
            return "bus.fill"
        case .walk:
            return "figure.walk"
        }
    }
}
