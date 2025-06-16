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

}

extension FlightEntity : Identifiable {

}
