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
        } catch let error as NSError {
            print("❌ CoreData Save Error: \(error.localizedDescription), \(error.userInfo)")
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
        
        print("✅ 저장 완료")
        
        return entity
    }
    
    func update<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate,
        configure: (T) -> Void
    ) -> T? {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        do {
            if let object = try context.fetch(fetchRequest).first {
                configure(object)
                saveContext()
                print("✅ 업데이트 완료")
                return object
            } else {
                print("❌ 업데이트할 객체를 찾을 수 없음: \(entityName)")
                return nil
            }
        } catch {
            print("❌ 업데이트 실패: \(error)")
            return nil
        }
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
    
    func update<Root, Value>(_ keyPath: ReferenceWritableKeyPath<Root, Value>, value: Value, for root: Root) {
        root[keyPath: keyPath] = value
        saveContext()
    }
    
    func update() {
        saveContext()
    }
    
    func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
        saveContext()
    }
    
    func delete<T: NSManagedObject>(
        _ type: T.Type,
        predicate: NSPredicate
    ) {
        let entityName = String(describing: type)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.predicate = predicate

        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }

            saveContext()
            print("✅ 삭제 완료")
        } catch {
            print("❌ 삭제 실패: \(error)")
        }
    }

}

