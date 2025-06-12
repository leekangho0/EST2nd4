//
//  TravelDTO.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import UIKit

struct Travel {
    let id: UUID
    var title: String
    var startDate, endDate: Date
    var schedules: [Schedule] = []
    var isBookmarked: Bool
    var startflight: FlightDTO
    var endFlight: FlightDTO
}

struct Schedule {
    let id: UUID
    let date: Date
    let travelID: UUID
    let places: [PlaceDTO]
}

struct PlaceDTO {
    let id: UUID
    let scheduleID: UUID
    let name: String
    let latitude, longittude: Double
    let address: String
    let category: CategoryDTO
    let memo: String?
    let expense: Expense?
    let photo: Data?
    let arrivalTime: Date?
}

struct Expense {
    let category: CategoryDTO
    let amount: String
    let memo: String
    let payerCount: Int
    let paymentType: PaymentType
}

enum PaymentType: Int16 {
    case card
    case cash
}

enum CategoryType: Int16 {
    case accmodation
    case cafe
    case restaurant
    case transportation
    case travel
    case shopping
    case etc
}

struct FlightDTO {
    let airline: String
    let flightNumber: String
    let departureTime: Date
    let arrivalTime: Date
    let departureAirport: String
    let arrivalAirport: String
}

struct CategoryDTO {
    let type: CategoryType
    let name: String
}

extension CategoryType {
    var imageName: String {
        switch self {
        case .accmodation:
            return "house"
        case .cafe:
            return "cup.and.saucer.fill"
        case .restaurant:
            return "fork.knife"
        case .transportation:
            return "bus"
        case .travel:
            return "sailboat"
        case .shopping:
            return "bag"
        case .etc:
            return "ellipsis.circle.fill"
        }
    }
}

extension CategoryDTO {
    var image: UIImage? {
        UIImage(systemName: type.imageName)
    }
}
