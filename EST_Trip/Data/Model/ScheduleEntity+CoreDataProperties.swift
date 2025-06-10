//
//  ScheduleEntity+CoreDataProperties.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//
//

import Foundation
import CoreData


extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "Schedule")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var travelId: UUID?
    @NSManaged public var places: NSSet?
    @NSManaged public var travel: TravelEntity?

}

// MARK: Generated accessors for places
extension ScheduleEntity {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: PlaceEntity)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: PlaceEntity)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

extension ScheduleEntity : Identifiable {

}
