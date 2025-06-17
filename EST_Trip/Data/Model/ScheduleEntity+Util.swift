//
//  ScheduleEntity+Util.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import CoreData

extension ScheduleEntity {
    var orderedPlaces: [PlaceEntity] {
        places?.compactMap { $0 as? PlaceEntity } ?? []
    }
}
