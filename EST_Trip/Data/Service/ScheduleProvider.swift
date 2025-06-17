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
}

extension ScheduleProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
    }
    private func controllerDidChangeContent(_ controller: NSFetchedResultsController<ScheduleEntity>) {
        
        notify()
    }
}
