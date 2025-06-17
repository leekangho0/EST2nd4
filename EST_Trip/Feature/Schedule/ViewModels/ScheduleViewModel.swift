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
    private let travelProvider: TravelProvider
    
    let travel: TravelEntity
    
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
    
    init(
        travel: TravelEntity,
        scheduleProvider: ScheduleProvider,
        travelProvider: TravelProvider
    ) {
        self.travel = travel
        self.scheduleProvider = scheduleProvider
        self.travelProvider = travelProvider
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
    }
}

extension ScheduleViewModel: ScheduleProviderDelegate {
    func scheduleProviderDidUpdate(_ schedules: [ScheduleEntity]) {
        self.schedules = schedules
        self.reloadClosure?()
    }
}
