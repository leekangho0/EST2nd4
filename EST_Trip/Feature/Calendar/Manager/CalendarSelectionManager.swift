//
//  CalendarSelectionManager.swift
//  EST_Trip
//
//  Created by hyunMac on 6/8/25.
//

import Foundation

class CalendarSelectionManager {
    private var travelDate = TravelDate()

    // 달력의 날짜 선택
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

    // 해당 날짜가 선택된 날짜 구간에 포함되는지 확인 (선 UI보여줘야 함)
    func isInSelectedRange(_ date: Date) -> Bool {
		guard let startDate = travelDate.startDate,
              let endDate = travelDate.endDate else { return false }
        return date > startDate && date < endDate
    }

    // 해당 날짜가 Start혹은 endDate인지 확인 (해당 날짜가 StartDate이나 EndDate이면 다른 UI를 적용해야함)
    func isStartOrEndDate(_ date: Date) -> Bool {
        return date == travelDate.startDate || date == travelDate.endDate
    }
}
