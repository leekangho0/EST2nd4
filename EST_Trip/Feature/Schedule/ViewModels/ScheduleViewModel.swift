//
//  ScheduleViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/17/25.
//

import Foundation
import CoreData

class ScheduleViewModel {
    private var travel: Travel?
    
    var schedules: [Schedule] = [] {
        didSet {
            travel?.schedules = schedules
        }
    }
    
    var scheduleCount: Int {
        return schedules.count
    }
    
    var startFlightAirport: String? {
        return travel?.startFlight?.arrivalAirport
    }
    
    var startFlightArrivalTime: String? {
        return travel?.startFlight?.arrivalTime?.timeToString(suffix: "도착")
    }
    
    var endFlightAirport: String? {
        return travel?.endFlight?.departureAirport
    }
    
    var endFlightDepartureTime: String? {
        return travel?.endFlight?.departureTime?.timeToString(suffix: "출발")
    }
    
    var startDate: Date? {
        return travel?.startDate
    }
    
    var endDate: Date? {
        return travel?.endDate
    }
    
    func place(section: Int, index: Int) -> PlaceDTO {
        return schedules[section].places[index]
    }
    
    func placeCount(section: Int) -> Int {
        return schedules[section].places.count
    }
    
    func dateToString(section: Int) -> String {
        return schedules[section].date?.toString() ?? "-"
    }
    
    func hasStartFlight() -> Bool {
        self.travel?.startFlight?.airline != nil
    }
    
    func hasEndFlight() -> Bool {
        self.travel?.endFlight?.airline != nil
    }
    
    func isLastSection(_ section: Int) -> Bool {
        schedules.count - 1 == section
    }
    
    func isLastIndex(_ section: Int, _ index: Int) -> Bool {
        schedules[section].places.count - 1 == index
    }
}

// MARK: - Set up Datas
extension ScheduleViewModel {
    func setTravel(_ travel: Travel?) {
        self.travel = travel
        schedules = travel?.schedules.map { schedule in
            var sortedSchedule = schedule
            sortedSchedule.places.sort { ($0.index ?? 0) < ($1.index ?? 0) }
            return sortedSchedule
        } ?? []
    }
    
    func addSchedule(_ schedule: ScheduleEntity) {
        if let date = schedule.date,
           let travelId = schedule.travelId {
            schedules.append(
                Schedule(
                    id: schedule.id,
                    date: date,
                    travelID: travelId,
                    places: []
                )
            )
        }
    }
    
    func addPlace(to section: Int, _ place: PlaceDTO) {
        schedules[section].places.append(place)
    }
    
    func insertPlace(to section: Int, at index: Int, _ place: PlaceDTO) {
        schedules[section].places.insert(place, at: index)
    }
    
    func removePlace(from section: Int, _ placeID: UUID) {
        if let index = schedules[section].places.firstIndex(where: { $0.id == placeID }) {
            schedules[section].places.remove(at: index)
        }
    }
    
    func movePlace(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let place = schedules[sourceIndexPath.section].places.remove(at: sourceIndexPath.row)
//        schedules[destinationIndexPath.section].places.insert(place, at: destinationIndexPath.row)
    }
}

// MARK: - Travel CRUD
extension ScheduleViewModel {
    func createTravel(_ travel: Travel?, completion: () -> Void ) {
        self.travel = travel
        
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        CoreDataManager.shared.insert(TravelEntity.self) { entity in
            entity.id = travel.id
            entity.title = "제주여행"
            entity.startDate = travel.startDate
            entity.endDate = travel.endDate
            entity.startFlight = travel.startFlight?.toEntity()
            
            if let startDate = travel.startDate, let endDate = travel.endDate {
                let dates = startDate.datesUntil(endDate)
                
                dates.forEach {
                    let schedule = ScheduleEntity(
                        context: CoreDataManager.shared.context,
                        date: $0,
                        travelId: travel.id,
                        places: []
                    )
                    
                    entity.addToSchedules(schedule)
                    
                    self.addSchedule(schedule)
                }
                
                completion()
            }
       }
    }
    
    func deleteTravel() {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)

        CoreDataManager.shared.delete(TravelEntity.self, predicate: predicate)
    }
    
    func updateTravelTitle(_ title: String) {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)

        let _ = CoreDataManager.shared.update(TravelEntity.self, predicate: predicate) { entity in
            entity.title = title
        }
        
        self.travel?.title = title
    }
    
    func updateTravelDate(startDate: Date, endDate: Date) {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)

        let _ = CoreDataManager.shared.update(TravelEntity.self, predicate: predicate) { entity in
            entity.startDate = startDate
            entity.endDate = endDate
        }
        
        self.travel?.startDate = startDate
        self.travel?.endDate = endDate
    }
    
    func updateTravelStartFlight(_ flight: FlightDTO) {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)

        let _ = CoreDataManager.shared.update(TravelEntity.self, predicate: predicate) { entity in
            entity.startFlight = flight.toEntity()
        }
        
        self.travel?.startFlight = flight
    }
    
    func updateTravelEndFlight(_ flight: FlightDTO) {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)

        let _ = CoreDataManager.shared.update(TravelEntity.self, predicate: predicate) { entity in
            entity.endFlight = flight.toEntity()
        }
        
        self.travel?.endFlight = flight
    }
}

// MARK: - Place CRUD
extension ScheduleViewModel {
    func addPlace(to section: Int, place: PlaceDTO, completion: () -> Void) {
        guard let travel else { print("❌ Travel Nil Data Error"); return }
        
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TravelEntity> = TravelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)
        
        do {
            // 1. TravelEntity 찾기
            if let travelEntity = try context.fetch(fetchRequest).first {
                
                // 2. schedules에서 원하는 ScheduleEntity 찾기
                let scheduleID = schedules[section].id
                
                guard let scheduleEntities = travelEntity.schedules as? Set<ScheduleEntity>,
                      let matchedSchedule = scheduleEntities.first(where: { $0.id == scheduleID }) else {
                    print("❌ ScheduleEntity not found")
                    return
                }

                // 3. PlaceEntity 생성
                let placeEntity = PlaceEntity(
                    context: context,
                    id: place.id,
                    address: place.address,
                    latitude: place.latitude,
                    longitude: place.longitude,
                    name: place.name,
                    scheduleID: scheduleID,
                    index: Int16(placeCount(section: section))
                )

                // 4. 추가
                matchedSchedule.addToPlaces(placeEntity)

                // 5. 저장
                CoreDataManager.shared.saveContext()
                
                // 6. ViewModel에 데이터 업데이트
                addPlace(to: section, place)
                completion()
                print("✅ Place added to schedule")
            } else {
                print("❌ TravelEntity not found")
            }
        } catch {
            print("❌ Fetch error: \(error)")
        }
    }
    
    func insertPlace(to section: Int, at index: Int, place: PlaceDTO, completion: (() -> Void)? = nil) {
        guard let travel else { print("❌ Travel Nil Data Error"); return }
        
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TravelEntity> = TravelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)
        
        do {
            // 1. TravelEntity 찾기
            if let travelEntity = try context.fetch(fetchRequest).first {
                
                // 2. schedules에서 원하는 ScheduleEntity 찾기
                let scheduleID = schedules[section].id
                
                guard let scheduleEntities = travelEntity.schedules as? Set<ScheduleEntity>,
                      let matchedSchedule = scheduleEntities.first(where: { $0.id == scheduleID }) else {
                    print("❌ ScheduleEntity not found")
                    return
                }
                
                // 3. schedule에 해당하는 PlaceEntity 불러오기
                guard let placeEntities = matchedSchedule.places as? Set<PlaceEntity> else {
                    print("❌ PlaceEntity to update not found")
                    return
                }
                
                // 4. Update index
                for place in placeEntities {
                    if place.index >= index {
                        place.index += 1
                    }
                 }
                
                // 5. PlaceEntity 추가
                let placeEntity = PlaceEntity(
                    context: context,
                    id: place.id,
                    address: place.address,
                    latitude: place.latitude,
                    longitude: place.longitude,
                    name: place.name,
                    scheduleID: scheduleID,
                    index: Int16(index + 1) // index는 1부터 시작
                )
                
                matchedSchedule.addToPlaces(placeEntity)

                // 6. Data 저장
                CoreDataManager.shared.saveContext()
                
                // 7. Update self
                insertPlace(to: section, at: index, place)
                completion?()
                print("✅ Place inserted to schedule")
            } else {
                print("❌ TravelEntity not found")
            }
        } catch {
            print("❌ Fetch error: \(error)")
        }
    }
    
    func deletePlace(from section: Int, _ index: Int, completion: (() -> Void)? = nil) {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }

        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TravelEntity> = TravelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)
        
        do {
            // 1. TravelEntity 찾기
            if let travelEntity = try context.fetch(fetchRequest).first {
                
                // 2. schedules에서 원하는 ScheduleEntity 찾기
                let scheduleID = schedules[section].id
                guard let scheduleEntities = travelEntity.schedules as? Set<ScheduleEntity>,
                      let matchedSchedule = scheduleEntities.first(where: { $0.id == scheduleID }) else {
                    print("❌ ScheduleEntity not found")
                    return
                }
                
                // 3. matchedSchedule에 있는 places에서 삭제할 PlaceEntity 찾기
                let placeID = place(section: section, index: index).id
                
                guard let placeEntities = matchedSchedule.places as? Set<PlaceEntity>,
                      let placeToRemove = placeEntities.first(where: { $0.id == placeID }) else {
                    print("❌ PlaceEntity to remove not found")
                    return
                }
                
                // 4. PlaceEntity 삭제
                matchedSchedule.removeFromPlaces(placeToRemove)
                context.delete(placeToRemove)
                
                // 5. 저장
                CoreDataManager.shared.saveContext()
                
                // 6. ViewModel에 데이터도 업데이트 (배열 등에서 제거)
                removePlace(from: section, placeID)
                completion?()
                print("✅ Place removed from schedule")
                
            } else {
                print("❌ TravelEntity not found")
            }
        } catch {
            print("❌ Fetch error: \(error)")
        }
    }
    
    func updatePlace(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, completion: (() -> Void)? = nil) {
        guard let travel else {
            print("❌ Travel Nil Data Error")
            return
        }
        
        let oldSection = sourceIndexPath.section
        let oldIndex = sourceIndexPath.row
        
        let newSection = destinationIndexPath.section
        let newIndex = destinationIndexPath.row
        
        let updatedPlace = place(section: oldSection, index: oldIndex)
        
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TravelEntity> = TravelEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", travel.id as CVarArg)
        
        do {
            // 1. TravelEntity 찾기
            if let travelEntity = try context.fetch(fetchRequest).first {
                // 2. schedules에서 원하는 ScheduleEntity 찾기
                // 2-1. section이 다를 경우
                if oldSection != newSection {
                    deletePlace(from: oldSection, oldIndex)
                    insertPlace(to: newSection, at: newIndex, place: updatedPlace)
                }
                // 2-2. section이 같을 경우
                else {
                    let scheduleID = schedules[newSection].id
                    
                    guard let scheduleEntities = travelEntity.schedules as? Set<ScheduleEntity>,
                          let matchedSchedule = scheduleEntities.first(where: { $0.id == scheduleID }) else {
                        print("❌ ScheduleEntity not found")
                        return
                    }
                    
                    // 3. matchedSchedule.places에서 수정할 PlaceEntity 찾기
                    guard let placeEntities = matchedSchedule.places as? Set<PlaceEntity>,
                            let placeToUpdate = placeEntities.first(where: { $0.id == updatedPlace.id }) else {
                        print("❌ PlaceEntity to update not found")
                        return
                    }
                    
                    for place in placeEntities {
                         if place == placeToUpdate { continue } // 자기 자신 제외
                         
                         if oldIndex < newIndex {
                             // index가 oldIndex < index <= newIndex 인 것들은 1씩 감소
                             if place.index > oldIndex && place.index <= newIndex {
                                 place.index -= 1
                             }
                         } else {
                             // index가 newIndex <= index < oldIndex 인 것들은 1씩 증가
                             if place.index >= newIndex && place.index < oldIndex {
                                 place.index += 1
                             }
                         }
                     }
                    
                    // 자기 자신은 마지막에 Update
                    placeToUpdate.index = Int16(newIndex)
                }
                
                // 5. 저장
                CoreDataManager.shared.saveContext()
                
                // 6. ViewModel 데이터 업데이트
                movePlace(moveRowAt: sourceIndexPath, to: destinationIndexPath)
                
                completion?()
                print("✅ Place updated in schedule")
            } else {
                print("❌ TravelEntity not found")
            }
        } catch {
            print("❌ Fetch error: \(error)")
        }
    }
}
