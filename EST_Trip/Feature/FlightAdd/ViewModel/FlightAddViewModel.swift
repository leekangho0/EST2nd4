//
//  FlightAddViewModel.swift
//  EST_Trip
//
//  Created by hyunMac on 6/11/25.
//

import Foundation

final class FlightAddViewModel {
    var flight = Flight()

    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy.M.d"
        return f
    }()

    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

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
