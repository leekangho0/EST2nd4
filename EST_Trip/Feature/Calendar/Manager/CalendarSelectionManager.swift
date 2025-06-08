//
//  CalendarSelectionManager.swift
//  EST_Trip
//
//  Created by hyunMac on 6/8/25.
//

import Foundation

class CalendarSelectionManager {
    private var travelDate = TravelDate()

    func select(date: Date) {
        // 아무 날짜도 선택이 안된 상태
        if travelDate.startDate == nil {
            travelDate.startDate = date

        }
        // startDate만 들어가 있는 경우 (날짜 하나만 선택된 상태)
        else if travelDate.endDate == nil {
            // 같은 날짜 다시 누르면 변화 없음
            if date == travelDate.startDate {
                return
            }

            // 새로 선택한 날짜가 startDate보다 이전이면 endDate와 스왑해서 설정하기
            guard let startDate = travelDate.startDate else { return }
            if date < startDate {
                travelDate.endDate = travelDate.startDate
                travelDate.startDate = date
            } else {
                travelDate.endDate = date
            }
        }
        // startDate, endDate 둘 다 선택된 상태에서 다시 날짜 클릭됨 -> 초기화
        else {
            travelDate.startDate = date
            travelDate.endDate = nil
        }
    }
}
