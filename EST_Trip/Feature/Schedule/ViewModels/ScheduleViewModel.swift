//
//  ScheduleViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/17/25.
//

import Foundation
import CoreData

enum TravelChange {
    case title(String)
    case date(String)
    case flight
}

class ScheduleViewModel {
    private var scheduleProvider: ScheduleProvider
    private let travelProvider: TravelProvider
    
    var travel: TravelEntity
    
    var schedules: [ScheduleEntity] = []
//    var headerTitles: [String] = ["", "", ""]
    
    var reloadClosure: (() -> Void)?
    var onTravelChanged: ((TravelChange) -> Void)?
    
    let sectionHeight: CGFloat = 80
    
    var startFlight: FlightDTO?
    var endFlight: FlightDTO?
    
    var updatedSectionHeight: CGFloat {
        sectionHeight * CGFloat(numberOfSections)
    }
    
    var numberOfSections: Int {
        schedules.count
    }
    
    var title: String? {
        travel.title
    }

    var startFlightAirport: String? {
        return startFlight?.departureAirport
    }
    
    var startFlightArrivalTime: String? {
        return startFlight?.arrivalTime?.timeToString(suffix: "도착")
    }
    
    var endFlightAirport: String? {
        return endFlight?.departureAirport
    }
    
    var endFlightDepartureTime: String? {
        return endFlight?.departureTime?.timeToString(suffix: "출발")
    }
    
    var startDate: Date? {
        return travel.startDate
    }
    
    var endDate: Date? {
        return travel.endDate
    }
    
    func place(section: Int, index: Int) -> PlaceEntity {
        return schedules[section].orderedPlaces[index]
    }
    
    var dateRangeTitle: String? {
        Date.range(start: travel.startDate ?? .now, end: travel.endDate ?? .now)
    }
    

    init(
        travel: TravelEntity,
        scheduleProvider: ScheduleProvider,
        travelProvider: TravelProvider
    ) {
        self.travel = travel
        
        self.startFlight = FlightDTO(entity: travel.startFlight)
        self.endFlight = FlightDTO(entity: travel.endFlight)
        
        self.scheduleProvider = scheduleProvider
        self.travelProvider = travelProvider
        
        dump(travel)
    }
    
    func bind(reloadAction: @escaping () -> Void) {
        scheduleProvider.delegate = self
        self.reloadClosure = reloadAction
    }
    
    func notify() {
        scheduleProvider.notify()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        schedules[section].orderedPlaces.count
    }
    
    func item(for indexPath: IndexPath) -> PlaceEntity {
        schedules[indexPath.section].orderedPlaces[indexPath.item]
    }
    
    func headerTitle(section: Int) -> String? {
        return schedules[section].date?.toString()
    }
    
    func delteTravel() {
        travelProvider.delete(entity: travel)
    }
    
    func updateTitle(_ text: String) {
        travelProvider.updateTitle(text, entity: travel)
        onTravelChanged?(.title(text))
        
        travel.title = title
    }
    
    func updateDate(start: Date, end: Date) {
        travelProvider.updateDate(start: start, end: end, entity: travel)
        onTravelChanged?(.date(Date.range(start: start, end: end)))
        
        travel.startDate = start
        travel.endDate = end
    }
    
    func updateStartFlight(flight: FlightDTO) {
        travelProvider.addStartFlight(entity: travel, flight: flight)
        startFlight = flight
        
        onTravelChanged?(.flight)
    }
    
    func updateEndFlight(flight: FlightDTO) {
        travelProvider.addEndFlight(entity: travel, flight: flight)
        endFlight = flight
        
        onTravelChanged?(.flight)
    }
    
    func addPlace(_ item: GooglePlaceDTO, _ section: Int) {
        scheduleProvider.addPlace(item, entity: schedules[section])
    }
    
    func addPlace(_ item: PlaceDTO, _ section: Int) {
        scheduleProvider.addPlace(item, entity: schedules[section])
    }
        
    func dateToString(section: Int) -> String {
        return schedules[section].date?.toString() ?? "-"
    }
    
    func hasStartFlight() -> Bool {
        return startFlight?.arrivalAirport != nil
    }
    
    func hasEndFlight() -> Bool {
        return endFlight?.arrivalAirport != nil
    }
    
    func isLastSection(_ section: Int) -> Bool {
        schedules.count - 1 == section
    }
    
    func isLastIndex(_ section: Int, _ index: Int) -> Bool {
        schedules[section].orderedPlaces.count - 1 == index
    }
    
    func movePlace(_ source: IndexPath, _ destination: IndexPath) {

        scheduleProvider.movePlace(in: schedules, from: source, to: destination)
    }
    
    func removePlace(_ indexPath: IndexPath) {
        let entity = schedules[indexPath.section]
        scheduleProvider.removePlace(in: entity, from: indexPath.item)
        schedules[indexPath.section] = entity
    }

//    // MARK: - Set up Datas
//    extension ScheduleViewModel {
//        func setTravel(_ travel: Travel?) {
}


extension ScheduleViewModel: ScheduleProviderDelegate {
    func scheduleProviderDidUpdate(_ schedules: [ScheduleEntity]) {
        self.schedules = schedules
        self.reloadClosure?()
    }
}

// MARK: - Update Place
extension ScheduleViewModel {
    func updatePlaceMemo(in section: Int, placeID: UUID, memo: String) {
        let predicate = NSPredicate(format: "id == %@", placeID as CVarArg)

        let _ = CoreDataManager.shared.update(PlaceEntity.self, predicate: predicate) { entity in
            entity.memo = memo
        }
        
        if let index = self.schedules[section].orderedPlaces.firstIndex(where: { $0.id == placeID }) {
            schedules[section].orderedPlaces[index].memo = memo
        }
    }
    
    func updatePlaceTime(in section: Int, placeID: UUID, time: Date) {
        let predicate = NSPredicate(format: "id == %@", placeID as CVarArg)

        let _ = CoreDataManager.shared.update(PlaceEntity.self, predicate: predicate) { entity in
            entity.arrivalTime = time
        }
        
        if let index = self.schedules[section].orderedPlaces.firstIndex(where: { $0.id == placeID }) {
            schedules[section].orderedPlaces[index].arrivalTime = time
        }
    }
}
