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
    
    init(
        id: UUID = UUID(),
        title: String = "제주 여행",
        startDate: Date? = nil,
        endDate: Date? = nil,
        schedules: [Schedule] = [],
        isBookmarked: Bool = false,
        startFlight: FlightDTO? = nil,
        endFlight: FlightDTO? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.schedules = schedules
        self.isBookmarked = isBookmarked
        self.startFlight = startFlight
        self.endFlight = endFlight
    }
    
    init(entity: TravelEntity) {
        self.id = entity.id
        self.title = entity.title ?? "-"
        self.startDate = entity.startDate
        self.endDate = entity.endDate
        self.startFlight = FlightDTO(entity: entity.startFlight)
        self.endFlight = FlightDTO(entity: entity.endFlight)
        
        if let scheduleEntities = entity.schedules as? Set<ScheduleEntity> {
            self.schedules = scheduleEntities
                .sorted { $0.date ?? Date() < $1.date ?? Date() }
                .map { Schedule(entity: $0) }
        }
    }
}

struct Schedule {
    let id: UUID
    let date: Date?
    let travelID: UUID?
    var places: [PlaceDTO]
    
    init(
        id: UUID = UUID(),
        date: Date? = nil,
        travelID: UUID? = nil,
        places: [PlaceDTO] = []
    ) {
        self.id = id
        self.date = date
        self.travelID = travelID
        self.places = places
    }
    
    init(entity: ScheduleEntity) {
        self.id = entity.id
        self.date = entity.date
        self.travelID = entity.travelId
        var places = [PlaceDTO]()
        
        if let placeEntities = entity.places as? Set<PlaceEntity> {
            places = placeEntities
                .sorted { $0.index < $1.index }
                .map { PlaceDTO(entity: $0) }
        }
        
        self.places = places
    }
}

struct PlaceDTO {
    var id: UUID
    var scheduleID: UUID? = nil
    let name: String?
    let latitude, longitude: Double
    let address: String?
    var category: CategoryDTO? = nil
    var memo: String? = nil
    var expense: Expense? = nil
    var photo: Data? = nil
    var arrivalTime: Date? = nil
    var index: Int? = nil
    
    init(
        id: UUID,
        scheduleID: UUID? = nil,
        name: String?,
        latitude: Double,
        longitude: Double,
        address: String?,
        category: CategoryDTO? = nil,
        memo: String? = nil,
        expense: Expense? = nil,
        photo: Data? = nil,
        arrivalTime: Date? = nil,
        index: Int? = nil
    ) {
        self.id = id
        self.scheduleID = scheduleID
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.category = category
        self.memo = memo
        self.expense = expense
        self.photo = photo
        self.arrivalTime = arrivalTime
    }
    
    init(entity: PlaceEntity) {
        self.id = entity.id
        self.scheduleID = entity.scheduleID
        self.name = entity.name
        self.latitude = entity.latitude
        self.longitude = entity.longitude
        self.address = entity.address
//        self.category =
        self.memo = entity.memo
//        self.expense =
//        self.photo =
        self.arrivalTime = entity.arrivalTime
        self.index = Int(entity.index)
    }
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
    
    var image: UIImage? {
        UIImage(systemName: imageName)
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
