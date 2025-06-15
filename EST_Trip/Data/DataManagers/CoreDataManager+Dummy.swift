//
//  PlaceDataManager+Dummy.swift
//  EST_Trip
//
//  Created by 권도현 on 6/13/25.
//

import Foundation
import CoreData


extension CoreDataManager {
    func insertDummyData() {
        // TravelEntity에 저장된 데이터가 있는지 확인
        let existingTravels = fetch(TravelEntity.self)
        if !existingTravels.isEmpty {
            return
        }
        
        // 샘플 데이터 (필요 시 외부 파일에서 불러와도 됨)
        let dummyTitles = [
            "제주도 여행",
            "부산 바다 투어",
            "서울 역사 탐방"
        ]
        
        let calendar = Calendar.current
        let today = Date()

        for (index, title) in dummyTitles.enumerated() {
            insert(TravelEntity.self) { entity in
                entity.id = UUID()
                entity.title = title
                entity.startDate = calendar.date(byAdding: .day, value: index * 7, to: today) ?? today
                entity.endDate = calendar.date(byAdding: .day, value: (index * 7) + 3, to: today) ?? today
                entity.isBookmarked = false
            }
        }

        saveContext()
    }
}
