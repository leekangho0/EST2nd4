//
//  TravelDTO.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import UIKit
import CoreData

struct Travel {
    var id: UUID = UUID()
    var title: String = "제주 여행"
    var startDate, endDate: Date?
    var schedules: [Schedule] = []
    var isBookmarked: Bool = false
    var startFlight: FlightDTO?
    var endFlight: FlightDTO?
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
    
    var name: String {
        switch self {
        case .accmodation:
            return "숙소"
        case .cafe:
            return "카페"
        case .restaurant:
            return "음식점"
        case .transportation:
            return "교통"
        case .travel:
            return "관광"
        case .shopping:
            return "쇼핑"
        case .etc:
            return "기타"
        }
    }
}

struct FlightDTO {
    var airline: String?
    var flightNumber: String?
    var departureDate: Date?
    var departureTime: Date?
    var arrivalTime: Date?
    var departureAirport: String?
    var arrivalAirport: String?
    var arrivalDate: Date?
    
    func toEntity(context: NSManagedObjectContext) -> FlightEntity {
        return FlightEntity(
            context: context,
            departureDate: self.departureDate,
            departureAirport: self.departureAirport,
            departureTime: self.departureTime,
            flightname: self.airline,
            arrivalAirport: self.arrivalAirport,
            arrivalTime: self.arrivalTime,
            arrivalDate: self.arrivalDate
        )
    }
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
