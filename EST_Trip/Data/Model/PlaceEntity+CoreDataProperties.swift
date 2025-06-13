//
//  PlaceEntity+CoreDataProperties.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//
//

import Foundation
import CoreData


extension PlaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaceEntity> {
        return NSFetchRequest<PlaceEntity>(entityName: "Place")
    }

    @NSManaged public var address: String?
    @NSManaged public var arrivalTime: Date?
    @NSManaged public var id: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var memo: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var scheduleID: UUID
    @NSManaged public var category: Int16
    @NSManaged public var expense: ExpenseEntity?
    @NSManaged public var schedule: ScheduleEntity?

}

extension PlaceEntity : Identifiable {

}
