//
//  ScheduleProvider.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation
import CoreData

protocol ScheduleProviderDelegate: AnyObject {
    func scheduleProviderDidUpdate(_ schedules: [ScheduleEntity])
}

enum ScheduleChange {
    case insert(IndexPath)
    case delete(IndexPath)
    case move(IndexPath, IndexPath)
    case update(IndexPath)
}

final class ScheduleProvider: NSObject {
    private let storageProvider: CoreDataManager
    private let travel: TravelEntity
    
    weak var delegate: ScheduleProviderDelegate?
    
    init(travel: TravelEntity) {
        storageProvider = CoreDataManager.shared
        self.travel = travel
        super.init()
        
        performFetch()
    }
    
    // MARK: Read
    
    private lazy var frc: NSFetchedResultsController<ScheduleEntity> = {
        let request: NSFetchRequest<ScheduleEntity> = ScheduleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(ScheduleEntity.travel), travel)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ScheduleEntity.date, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: storageProvider.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    private func performFetch() {
        try? frc.performFetch()
    }
    
    func notify() {
        delegate?.scheduleProviderDidUpdate(frc.fetchedObjects ?? [])
    }
    
    func numberOfSections() -> Int {
        frc.fetchedObjects?.count ?? 0
    }
    
    func numberOfRowsInSections(for section: Int) -> Int {
        frc.fetchedObjects?[section].orderedPlaces.count ?? 0
    }
    
    func section(at indexPath: IndexPath) -> ScheduleEntity? {
        frc.object(at: indexPath)
    }
    
    func item(at indexPath: IndexPath) -> PlaceEntity? {
        frc.fetchedObjects?[indexPath.section].orderedPlaces[indexPath.item]
    }
    
    // MARK: Create
    
    func movePlace(in schedules: [ScheduleEntity], from sourceIndex: IndexPath, to destinationIndex: IndexPath) {
        let fromSection = schedules[sourceIndex.section]
        var fromPlaces = fromSection.orderedPlaces
        
        
        let toSection = schedules[destinationIndex.section]
        var toPlaces = toSection.orderedPlaces
        
        let moved = fromPlaces.remove(at: sourceIndex.item)
        toPlaces.insert(moved, at: destinationIndex.item)
        
        resetIndices(fromPlaces, parent: fromSection)
        resetIndices(toPlaces, parent: toSection)
        
        storageProvider.saveContext()
    }
    
    func removePlace(in schedule: ScheduleEntity, from sourceIndex: Int) {
        var places = schedule.orderedPlaces
        
        let removed = places.remove(at: sourceIndex)
        
        storageProvider.delete(removed)
        
        resetIndices(places, parent: schedule)
    }
    
    func addPlace(_ item: GooglePlaceDTO, entity: ScheduleEntity) {
        storageProvider.insert(PlaceEntity.self) { newEntity in
            item.apply(newEntity)
            newEntity.index = Int16(entity.orderedPlaces.endIndex)
            
            // relationship
            newEntity.schedule = entity
        }
    }
    
    func addPlace(_ item: PlaceDTO, entity: ScheduleEntity) {
        storageProvider.insert(PlaceEntity.self) { newEntity in
            item.apply(entity: newEntity)
            newEntity.index = Int16(entity.orderedPlaces.endIndex)
            
            // relationship
            newEntity.schedule = entity
        }
    }
    
    private func resetIndices(_ places: [PlaceEntity], parent: ScheduleEntity) {
        for (index, place) in places.enumerated() {
            place.index = Int16(index)
        }
        
        parent.places = NSOrderedSet(array: places)
        storageProvider.saveContext()
    }
}

extension ScheduleProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    }
    private func controllerDidChangeContent(_ controller: NSFetchedResultsController<ScheduleEntity>) {
        
        notify()
    }
}
