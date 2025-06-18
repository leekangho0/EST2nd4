//
//  DTO.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import CoreData

extension PlaceDTO {
    func apply(entity: PlaceEntity) {
        entity.name = name
        entity.latitude = latitude
        entity.address = address
        entity.categoryType = category?.type ?? .travel
//        entity.photo = photo
    }
}

extension FlightDTO {
    func apply(entity: FlightEntity) {
        entity.departureDate = departureDate
        entity.departureAirport = departureAirport
        entity.departureTime = departureTime
        entity.flightname = flightNumber
        entity.arrivalAirport = arrivalAirport
        entity.arrivalTime = arrivalTime
        entity.arrivalDate = arrivalDate
    }
}
