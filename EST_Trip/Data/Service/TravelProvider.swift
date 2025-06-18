//
//  TravelProvider.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import CoreData

protocol TravelProviderDelegate: AnyObject {
    func travelProviderDidUpdateUpcoming(_ travels: [TravelEntity])
    func travelProviderDidUpdatePrior(_ travels: [TravelEntity])
}

final class TravelProvider: NSObject {
    static let shared = TravelProvider()
    
    private let storageProvider: CoreDataManager
    
    weak var delegate: TravelProviderDelegate?
    
    private override init() {
        storageProvider = CoreDataManager.shared
        super.init()
        
        performFetch()
    }
    
    // MARK: Read
    
    private lazy var upcomingFRC: NSFetchedResultsController<TravelEntity> = {
        let request: NSFetchRequest<TravelEntity> = TravelEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TravelEntity.startDate, ascending: true)]
        request.predicate = NSPredicate(format: "%K >= %@", #keyPath(TravelEntity.startDate), NSDate())
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: storageProvider.context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private lazy var priorFRC: NSFetchedResultsController<TravelEntity> = {
        let request: NSFetchRequest<TravelEntity> = TravelEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TravelEntity.startDate, ascending: false)]
        request.predicate = NSPredicate(format: "%K < %@", #keyPath(TravelEntity.endDate), NSDate())
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: storageProvider.context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private func performFetch() {
        try? upcomingFRC.performFetch()
        try? priorFRC.performFetch()
    }
    
    func notifyAll() {
        delegate?.travelProviderDidUpdateUpcoming(upcomingFRC.fetchedObjects ?? [])
        delegate?.travelProviderDidUpdatePrior(priorFRC.fetchedObjects ?? [])
    }
}

extension TravelProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        notifyAll()
    }
}

// MARK: CRUD

extension TravelProvider {
    
    /// 날짜를 입력받아서 생성
    func create(start: Date, end: Date) -> TravelEntity? {
       let travelEntity = storageProvider.insert(TravelEntity.self) { entity in
            entity.startDate = start
            entity.endDate = end
           entity.title = "제주여행"
        }
        
        if let travelEntity {
            Date.makeDateRange(from: start, to: end).forEach { date in
                createSchedule(entity: travelEntity, places: [], date: date)
            }
        }
        
        return travelEntity
    }
    
    func delete(entity: TravelEntity) {
        storageProvider.delete(entity)
    }
    
    /// Flight 정보를 입력받아서 flight 갱신 또는 생성
    func addFlight(entity: TravelEntity, flight: FlightDTO) {
        if let exist = entity.startFlight {
            flight.apply(entity: exist)
            storageProvider.update()
        } else {
            
            // 존재하지 않으면 새로 생성 후 relationship
            storageProvider.insert(FlightEntity.self) { newEntity in
                flight.apply(entity: newEntity)
                entity.startFlight = newEntity
            }
        }
    }
    
    /// place array와 date를 입력 받아 새로운 Schedule 생성
    func createSchedule(entity: TravelEntity, places: [PlaceDTO], date: Date? = nil) {
        let scheduleEntity = storageProvider.insert(ScheduleEntity.self) { newEntity in
            newEntity.date = date
            newEntity.travel = entity
        }
        
        places.forEach { place in
            let placeEntity = storageProvider.insert(PlaceEntity.self) { newEntity in
                place.apply(entity: newEntity)
            }
            placeEntity?.schedule = scheduleEntity
        }
    }
}

extension TravelProvider {
    func updateTitle(_ text: String, entity: TravelEntity) {
        storageProvider.update(\TravelEntity.title, value: text, for: entity)
    }
    
    func updateDate(start: Date, end: Date, entity: TravelEntity) {
        storageProvider.update(\TravelEntity.startDate, value: start, for: entity)
        storageProvider.update(\TravelEntity.endDate, value: end, for: entity)
    }
    
    func updateStartFlight(flight: FlightEntity, entity: TravelEntity) {
        storageProvider.update(\TravelEntity.startFlight, value: flight, for: entity)
    }
    
    func updateEndFlight(flight: FlightEntity, entity: TravelEntity) {
        storageProvider.update(\TravelEntity.endFlight, value: flight, for: entity)
    }
}
