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

    @NSManaged public var id: UUID
    @NSManaged public var address: String?
    @NSManaged public var arrivalTime: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var memo: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var scheduleID: UUID
    @NSManaged public var category: Int16
    @NSManaged public var index: Int16
    @NSManaged public var schedule: ScheduleEntity?
    
    convenience init(
        context: NSManagedObjectContext,
        id: UUID,
        address: String?,
        arrivalTime: Date? = nil,
        latitude: Double,
        longitude: Double,
        memo: String? = nil,
        name: String? = nil,
        scheduleID: UUID,
        index: Int16,
        category: Int16? = nil
    ) {
        self.init(context: context)
        
        self.id = id
        self.address = address
        self.arrivalTime = arrivalTime
        self.latitude = latitude
        self.longitude = longitude
        self.memo = memo
        self.name = name
        self.scheduleID = scheduleID
        self.index = index
        self.category = category ?? 0
    }
}

extension PlaceEntity : Identifiable {
    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: PlaceEntity)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: PlaceEntity)
}
