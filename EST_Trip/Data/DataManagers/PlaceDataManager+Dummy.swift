////
////  PlaceDataManager+Dummy.swift
////  EST_Trip
////
////  Created by 권도현 on 6/13/25.
////
//
//import Foundation
//import CoreData
//
//
//extension CoreDataManager {
//    func insertDummyData() {
//        
//        guard let path = Bundle.main.path(forResource: "", ofType: "") else {
//            fatalError("경로를 가져오지 못함")
//        }
//        
//        do {
//            let countRequest = PlaceEntity.fetchRequest()
//            let count = try mainContext.fetch(countRequest).count
//            if count > 0 {
//                return
//            }
//            
//            let source = try String(contentsOfFile: path, encoding: .utf8)
//            
//            let sentences = source
//                .components(separatedBy: newlines)
//                .filter { $0.trimmingCharacters(in: whitespacesAndNewlines).count > 0 }
//            
//            var dataList = [[String: Any]]()
//            
//            for sentence in sentences {
//                <#body#>
//            }
//        } catch {
//            
//        }
//    }
//}
