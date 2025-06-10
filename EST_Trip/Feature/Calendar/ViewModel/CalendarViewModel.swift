//
//  CalendarViewModel.swift
//  EST_Trip
//
//  Created by hyunMac on 6/10/25.
//

import UIKit

final class CalendarViewModel {
    private let calendarManager = CalendarManager()
    private let selectionManager = CalendarSelectionManager()

    // MARK: - 달력 생성 파트
    // 섹션 수 조회
    var numberOfSections: Int {
        calendarManager.numberOfSections
    }
    // 섹션의 날짜 조회
    func dates(for section: Int) -> [CalendarDate] {
        calendarManager.dates(for: section)
    }
    // 섹션의 년 월 출력
    func title(for section: Int) -> String {
        calendarManager.title(for: section)
    }
    //!
    var todayIndexPath: IndexPath? {
        calendarManager.todayIndexPath
    }

    // MARK: - 날짜 선택 파트
    // 날짜 선택
    func select(date: Date) {
        selectionManager.select(date: date)
    }
    // travelDate 조회
    var travelDate: TravelDate {
        selectionManager.travelDate
    }
    // 선택된 날짜가 시작날짜인지 마지막 날짜인지 확인
    func isStartOrEndDate(_ date: Date) -> Bool {
        selectionManager.isStartOrEndDate(date)
    }
    // 선택된 날짜가 시작날짜와 마지막 날짜 사이인지 확인
    func isInSelectedRange(_ date: Date) -> Bool {
        selectionManager.isInSelectedRange(date)
    }
    // MARK: - 유틸
    func isToday(_ date: Date) -> Bool {
        calendarManager.isToday(date)
    }

    func isWeekend(_ date: Date) -> Bool {
        calendarManager.isWeekend(date)
    }
}
