//
//  PlaceEntity+Util.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation

extension PlaceEntity {
    
    var categoryType: CategoryType {
        get {
            CategoryType(rawValue: self.category) ?? .travel
        } set {
            self.category = newValue.rawValue
        }
    }
}
