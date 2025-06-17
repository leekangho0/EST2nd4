//
//  TravelEntity+CoreDataClass.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//
//

import Foundation
import CoreData

extension TravelEntity {
    static func sample(context: NSManagedObjectContext) -> TravelEntity {
        let entity = TravelEntity(context: context)
        
        entity.endDate = .now
        entity.startDate = .now
     
        return entity
    }
}
