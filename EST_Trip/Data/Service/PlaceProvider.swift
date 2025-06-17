//
//  PlaceProvider.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import CoreData

final class PlaceProvider {
    static let shared = PlaceProvider()
    
    private let storageProvider: CoreDataManager
    
    private init() {
        storageProvider = CoreDataManager.shared
    }
    
    // MARK: Read
}

extension PlaceProvider {
    
    // 날짜 입력 받음
    func create(_ places: [PlaceDTO], scheduleEntity: ScheduleEntity) {
        places.forEach { place in
            let placeEntity = storageProvider.insert(PlaceEntity.self) { newEntity in
                place.apply(entity: newEntity)
            }
            placeEntity?.schedule = scheduleEntity
        }
    }
}

// MARK: Update

extension PlaceProvider {
    
    func updateSchedule() {
        
    }
}
