//
//  FlightEntity+CoreDataProperties.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//
//

import Foundation
import CoreData


extension FlightEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightEntity> {
        return NSFetchRequest<FlightEntity>(entityName: "Flight")
    }

    @NSManaged public var id: UUID
    @NSManaged public var departureDate: Date?
    @NSManaged public var departureAirport: String?
    @NSManaged public var departureTime: Date?
    @NSManaged public var flightname: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var arrivalTime: Date?
    @NSManaged public var arrivalDate: Date?
    @NSManaged public var startFlight: TravelEntity?
    @NSManaged public var endFlight: TravelEntity?
    
    convenience init(
        context: NSManagedObjectContext,
        id: UUID = UUID(),
        departureDate: Date? = nil,
        departureAirport: String? = nil,
        departureTime: Date? = nil,
        flightname: String? = nil,
        arrivalAirport: String? = nil,
        arrivalTime: Date? = nil,
        arrivalDate: Date? = nil
    ) {
        self.init(context: context)
        self.id = id
        self.departureDate = departureDate
        self.departureAirport = departureAirport
        self.departureTime = departureTime
        self.flightname = flightname
        self.arrivalAirport = arrivalAirport
        self.arrivalTime = arrivalTime
        self.arrivalDate = arrivalDate
    }
}

extension FlightEntity : Identifiable {

}
