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
    
    public override var description: String {
        """
주소: \(self.address ?? "알 수 없음")
도착시간: \(self.arrivalTime?.timeToString() ?? "-") 
메모: \(self.memo ?? "-")
"""
    }
    
    var ratingText: String {
        String(format: "%.1f", rating) + "(\(reviewCount))"
    }
}
