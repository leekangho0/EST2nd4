//
//  SamPleTravelData.swift
//  EST_Trip
//
//  Created by kangho lee on 6/11/25.
//

import Foundation

// MARK: - Sample Data
extension Travel {
    static func makeJejuTrip() -> Travel {
        let travelID = UUID()
        let startDate = Date() // 오늘 기준
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        
        let flightToJeju = FlightDTO(
            flightName: "Korean Air",
            departureTime: startDate,
            arrivalTime: Calendar.current.date(byAdding: .hour, value: 1, to: startDate)!,
            departureAirport: "Gimpo",
            arrivalAirport: "Jeju"
        )
        
        let flightFromJeju = FlightDTO(
            flightName: "Jeju Air",
            departureTime: Calendar.current.date(byAdding: .day, value: 1, to: startDate)!,
            arrivalTime: Calendar.current.date(byAdding: .day, value: 1, to: startDate)!.addingTimeInterval(3600),
            departureAirport: "Jeju",
            arrivalAirport: "Gimpo"
        )
        
        let day1ScheduleID = UUID()
        let day2ScheduleID = UUID()
        
        let scheduleDay1 = Schedule(
            id: day1ScheduleID,
            date: startDate,
            travelID: travelID,
            places: makeDay1Places(scheduleID: day1ScheduleID, date: startDate)
        )
        
        let scheduleDay2 = Schedule(
            id: day2ScheduleID,
            date: endDate,
            travelID: travelID,
            places: makeDay1Places(scheduleID: day2ScheduleID, date: endDate)
        )
        
        let jejuTrip = Travel(
            id: travelID,
            title: "제주도 1박 2일 여행",
            startDate: startDate,
            endDate: endDate,
            schedules: [scheduleDay1, scheduleDay2],
            isBookmarked: true,
            startFlight: flightToJeju,
            endFlight: flightFromJeju
        )
        
        return jejuTrip
    }
    
    private static func makeDay1Places(scheduleID: UUID, date: Date) -> [PlaceDTO] {
        [/*
            PlaceDTO(
                id: UUID(),
                scheduleID: scheduleID,
                name: "협재 해수욕장",
                latitude: 33.3943,
                longittude: 126.2396,
                address: "제주시 한림읍 협재리",
                category: CategoryDTO(type: .travel, name: "해변"),
                memo: "사진 찍기 좋은 곳",
                expense: Expense(
                    category: CategoryDTO(type: .transportation, name: "렌터카"),
                    amount: "30000",
                    memo: "하루 렌트",
                    payerCount: 2,
                    paymentType: .card
                ),
                photo: nil,
                arrivalTime: Calendar.current.date(byAdding: .hour, value: 2, to: date)
            ),
            PlaceDTO(
                id: UUID(),
                scheduleID: scheduleID,
                name: "협재 해수욕장",
                latitude: 33.3943,
                longittude: 126.2396,
                address: "제주시 한림읍 협재리",
                category: CategoryDTO(type: .travel, name: "해변"),
                memo: "사진 찍기 좋은 곳",
                expense: Expense(
                    category: CategoryDTO(type: .transportation, name: "렌터카"),
                    amount: "30000",
                    memo: "하루 렌트",
                    payerCount: 2,
                    paymentType: .card
                ),
                photo: nil,
                arrivalTime: Calendar.current.date(byAdding: .hour, value: 2, to: date)
            ),
            PlaceDTO(
                id: UUID(),
                scheduleID: scheduleID,
                name: "용두암",
                latitude: 33.50,
                longittude: 126.50,
                address: "제주시 한림읍 협재리",
                category: CategoryDTO(type: .travel, name: "해변"),
                memo: "사진 찍기 좋은 곳",
                expense: Expense(
                    category: CategoryDTO(type: .transportation, name: "렌터카"),
                    amount: "30000",
                    memo: "하루 렌트",
                    payerCount: 2,
                    paymentType: .card
                ),
                photo: nil,
                arrivalTime: Calendar.current.date(byAdding: .hour, value: 2, to: date)
            ),
          */
        ]
    }
    
    private static func makeDay2Places(scheduleID: UUID, date: Date) -> [PlaceDTO] {
        [
            /*
            
            PlaceDTO(
                id: UUID(),
                scheduleID: scheduleID,
                name: "카페 봄날",
                latitude: 33.4912,
                longittude: 126.3805,
                address: "제주시 애월읍",
                category: CategoryDTO(type: .cafe, name: "카페"),
                memo: nil,
                expense: nil,
                photo: nil,
                arrivalTime: Calendar.current.date(byAdding: .hour, value: 10, to: date)
            ),
            
            PlaceDTO(
                id: UUID(),
                scheduleID: scheduleID,
                name: "협재 해수욕장",
                latitude: 33.4912,
                longittude: 126.2396,
                address: "제주시 한림읍 협재리",
                category: CategoryDTO(type: .travel, name: "해변"),
                memo: "사진 찍기 좋은 곳",
                expense: Expense(
                    category: CategoryDTO(type: .transportation, name: "렌터카"),
                    amount: "30000",
                    memo: "하루 렌트",
                    payerCount: 2,
                    paymentType: .card
                ),
                photo: nil,
                arrivalTime: Calendar.current.date(byAdding: .hour, value: 2, to: date)
            ),
            PlaceDTO(
                id: UUID(),
                scheduleID: scheduleID,
                name: "협재 해수욕장",
                latitude: 33.3943,
                longittude: 126.3805,
                address: "제주시 한림읍 협재리",
                category: CategoryDTO(type: .travel, name: "해변"),
                memo: "사진 찍기 좋은 곳",
                expense: Expense(
                    category: CategoryDTO(type: .transportation, name: "렌터카"),
                    amount: "30000",
                    memo: "하루 렌트",
                    payerCount: 2,
                    paymentType: .card
                ),
                photo: nil,
                arrivalTime: Calendar.current.date(byAdding: .hour, value: 2, to: date)
            ),
             */
        ]
    }
}


