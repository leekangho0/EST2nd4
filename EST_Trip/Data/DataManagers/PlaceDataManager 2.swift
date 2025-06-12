////
////  PlaceDataManager 2.swift
////  EST_Trip
////
////  Created by 권도현 on 6/12/25.
////
//
//
//import Foundation
//import CoreData
//
//class PlaceDataManager {
//    
//    static let shared = PlaceDataManager()
//    
//    let persistentContainer: NSPersistentContainer
//    let mainContext: NSManagedObjectContext
//    let fetchedResults: NSFetchedResultsController<PlaceEntity>
//    
//    //불러올수있는객체를 로드한다 container를 선언. context안에 db를 가져온다
//    
//    private init() {
//        let container = NSPersistentContainer(name: "Models")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        persistentContainer = container
//        mainContext =  persistentContainer.viewContext
//        
//        let request = PlaceEntity.fetchRequest()
//        
//        let sortByDateDesc = NSSortDescriptor(keyPath: \PlaceEntity.name, ascending: false)
//        request.sortDescriptors = [sortByDateDesc]
//        
//        fetchedResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do {
//            try fetchedResults.performFetch()
//        } catch {
//            print(error)
//        }
//    }
//    
//    
//    func fetch(keyword: String? = nil) {
//        
//        if let keyword {
//            let predicate = NSPredicate(format: "%K CONTAINS [c] %@", #keyPath(PlaceEntity.name), keyword)
//            fetchedResults.fetchRequest.predicate = predicate
//        } else {
//            fetchedResults.fetchRequest.predicate = nil
//        }
//        
//        do {
//            try fetchedResults.performFetch()
//        } catch {
//            print(error)
//        }
//    }
//    
//    func insert(memo: String) {
//        let newPlace = PlaceEntity(context: mainContext)
//        newPlace.name =
//        
//        
//        saveContext()
//     
//    }
//    
//    func update(entity: MemoEntity, with content: String) {
//        entity.content = content
//        saveContext()
//        
//    }
//    
//    func delete(entity: MemoEntity) {
//        mainContext.delete(entity)
//        saveContext()
//    }
//    
//    func delete(at indexPath: IndexPath) {
//        let target = fetchedResults.object(at: indexPath)
//        delete(entity: target)
//    }
//    
//    // MARK: - Core Data Saving support
//    
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//}
//
//
