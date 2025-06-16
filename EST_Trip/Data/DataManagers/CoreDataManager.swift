//
//  PlaceDataManager.swift
//  EST_Trip
//
//  Created by 권도현 on 6/12/25.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Models")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("❌ CoreData Save Error: \(error.localizedDescription)")
        }
    }
    
    @discardableResult
        func insert<T: NSManagedObject>(_ type: T.Type, configure: (T) -> Void) -> T? {
            let entityName = String(describing: type)

            guard let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T else {
                print("❌ Failed to create entity: \(entityName)")
                return nil
            }

            configure(entity)
            saveContext()
            return entity
        }
    
    
    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
            let request = NSFetchRequest<T>(entityName: String(describing: type))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors

            do {
                return try context.fetch(request)
            } catch {
                print("Failed to fetch \(type): \(error)")
                return []
            }
        }
    
    
        func update() {
            saveContext()
        }

        func delete<T: NSManagedObject>(_ object: T) {
            context.delete(object)
            saveContext()
        }
    
}

