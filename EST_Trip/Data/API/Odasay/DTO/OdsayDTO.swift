//
//  OdsayDTO.swift
//  EST_Trip
//
//  Created by kangho lee on 6/10/25.
//

import Foundation

struct RouteTransportDTO {
    let startX: Double
    let startY: Double
    let endX: Double
    let endY: Double
    
    init(startX: Double, startY: Double, endX: Double, endY: Double) {
        self.startX = startX
        self.startY = startY
        self.endX = endX
        self.endY = endY
    }
}
