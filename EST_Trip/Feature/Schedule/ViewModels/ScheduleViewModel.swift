//
//  ScheduleViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/17/25.
//

import Foundation

class ScheduleViewModel {
    var schedules: [Schedule] = []
    var headerTitles: [String] = ["", "", ""]
    
    var scheduleCount: Int {
        return schedules.count
    }
    
    func place(section: Int, index: Int) -> PlaceDTO {
        return schedules[section].places[index]
    }
    
    func placeCount(section: Int) -> Int {
        return schedules[section].places.count
    }
    
    func dateToString(section: Int) -> String {
        return schedules[section].date.toString()
    }
}

// MARK: - Travle CRUD
extension ScheduleViewModel {
    func createTravle(_ travle: Travel?) {
        guard let travle else {
            print("❌ Travle Nil Data Error")
            return
        }
        
        CoreDataManager.shared.insert(TravelEntity.self) { entity in
            entity.id = travle.id
            entity.title = "제주여행"
            entity.startDate = travle.startDate
            entity.endDate = travle.endDate
            entity.startFlight = travle.startFlight?.toEntity(context: CoreDataManager.shared.context)
            
            if let startDate = travle.startDate, let endDate = travle.endDate {
                let dates = startDate.datesUntil(endDate)
                
                dates.forEach {
                    entity
                        .addToSchedules(
                            ScheduleEntity(
                                context: CoreDataManager.shared.context,
                                date: $0,
                                travelId: travle.id,
                                places: []
                            )
                        )
                }
            }
       }
    }
    
    func deleteTravle() {
        
    }
    
    func updateTravle() {
        
    }
    
    func fetchTravle() {
        let travle = CoreDataManager.shared.fetch(TravelEntity.self)
        print("✅ 불러오기 완료")
        dump(travle)
    }
}

// MARK: - Place CRUD
extension ScheduleViewModel {
    func addPlace() {
        
    }
    
    func removePlace() {
        
    }
    
    func updatePlace() {
        
    }
}
