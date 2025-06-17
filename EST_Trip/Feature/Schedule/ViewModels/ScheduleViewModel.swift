//
//  ScheduleViewModel.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/17/25.
//

import Foundation
import CoreData

class ScheduleViewModel {
    private let scheduleProvider: ScheduleProvider
    let travel: TravelEntity
    
    var scheduleCount: Int {
        return schedules.count
    var schedules: [ScheduleEntity] = []
    var headerTitles: [String] = ["", "", ""]
    
    var reloadClosure: (() -> Void)?
    
    let sectionHeight: CGFloat = 80
    
    var updatedSectionHeight: CGFloat {
        sectionHeight * CGFloat(numberOfSections)
    }
    
    var numberOfSections: Int {
        schedules.count
    }
    
    init(travel: TravelEntity, scheduleProvider: ScheduleProvider) {
        self.travel = travel
        self.scheduleProvider = scheduleProvider
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
}

extension ScheduleViewModel: ScheduleProviderDelegate {
    func scheduleProviderDidUpdate(_ schedules: [ScheduleEntity]) {
        self.schedules = schedules
        self.reloadClosure?()
    }
}
//
//// MARK: - Travle CRUD
//extension ScheduleViewModel {
//    
//    func deleteTravle() {
//        
//    }
//    
//    func updateTravle() {
//        
//    }
//    
//    func fetchTravle() {
//        let travle = CoreDataManager.shared.fetch(TravelEntity.self)
//        print("✅ 불러오기 완료")
//        dump(travle)
//    }
//}
//
//// MARK: - Place CRUD
//extension ScheduleViewModel {
//    func addPlace() {
//        
//    }
//    
//    func removePlace() {
//        
//    }
//    
//    func updatePlace() {
//        
//    }
//}
