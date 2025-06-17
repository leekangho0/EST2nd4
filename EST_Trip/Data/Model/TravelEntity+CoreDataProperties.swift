//
//  TravelEntity+CoreDataProperties.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//
//

import Foundation
import CoreData


extension TravelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TravelEntity> {
        return NSFetchRequest<TravelEntity>(entityName: "TravelEntity")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var startFlight: FlightEntity?
    @NSManaged public var endFlight: FlightEntity?
    @NSManaged public var schedules: NSSet?
}

// MARK: Generated accessors for schedules
extension TravelEntity {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: ScheduleEntity)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: ScheduleEntity)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

extension TravelEntity : Identifiable {

}
