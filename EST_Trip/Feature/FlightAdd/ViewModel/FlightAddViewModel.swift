//
//  FlightAddViewModel.swift
//  EST_Trip
//
//  Created by hyunMac on 6/11/25.
//

import Foundation

final class FlightAddViewModel {
    let travel: TravelEntity
    
    var flight = FlightDTO()

    let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy.M.d"
        return f
    }()

    let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    init(travel: TravelEntity) {
        self.travel = travel
    }

    func updateFlightName(name: String) {
        flight.flightName = name
    }

    func updateDepartureDate(date: Date) -> String {
        flight.departureDate = date
        return dayFormatter.string(from: date)
    }

    func updateArrivalDate(date: Date) -> String {
        flight.arrivalDate = date
        return dayFormatter.string(from: date)
    }

    func updateDepartureTime(date: Date) -> String {
        flight.departureTime = date
        return timeFormatter.string(from: date)
    }

    func updateArrivalTime(date: Date) -> String {
        flight.arrivalTime = date
        return timeFormatter.string(from: date)
    }

    func updateDepartureAirport(airport: String) -> String {
        flight.departureAirport = airport
        return airport
    }

    func updateArrivalAirport(airport: String) -> String {
        flight.arrivalAirport = airport
        return airport
    }

    func updateTripDirection(isFirst: Bool) {
        if isFirst {
            flight.arrivalAirport   = "제주국제공항"
            flight.departureAirport = nil
        } else {
            flight.departureAirport = "제주국제공항"
            flight.arrivalAirport   = nil
        }
    }
}

extension FlightAddViewModel {
    func isFlightVaild() -> Bool {
        return flight.flightName?.isEmpty == false &&
        flight.departureDate != nil &&
        flight.departureTime != nil &&
        flight.arrivalDate != nil &&
        flight.arrivalTime != nil &&
        flight.departureAirport != nil &&
        flight.arrivalAirport != nil
    }


    func addFlight() {
        TravelProvider.shared.addStartFlight(entity: travel, flight: flight)
    }
    
    func saveToCoreData() {
        CoreDataManager.shared.insert(FlightEntity.self) { entity in
            entity.flightname = flight.flightName
            entity.departureDate = flight.departureDate
            entity.departureTime = flight.departureTime
            entity.arrivalDate = flight.departureDate
            entity.arrivalTime = flight.arrivalTime
            entity.departureAirport = flight.departureAirport
            entity.arrivalAirport = flight.arrivalAirport
        }
    }
    
//    func flightDTO() -> FlightDTO {
//        FlightDTO(
//            airline: flight.flightName,
//            departureDate: flight.departureDate,
//            departureTime: flight.departureDate,
//            arrivalTime: flight.arrivalTime,
//            departureAirport: flight.departureAirport,
//            arrivalAirport: flight.arrivalAirport,
//            arrivalDate: flight.arrivalDate
//        )
//    }
//
//    func updateTravle(travle: Travel?) -> Travel? {
//        var travle = travle
//        
//        travle?.startFlight = FlightDTO(
//            airline: flight.flightName,
//            departureDate: flight.departureDate,
//            departureTime: flight.departureDate,
//            arrivalTime: flight.arrivalTime,
//            departureAirport: flight.departureAirport,
//            arrivalAirport: flight.arrivalAirport,
//            arrivalDate: flight.arrivalDate
//        )
//        
//        return travle
//    }
}
