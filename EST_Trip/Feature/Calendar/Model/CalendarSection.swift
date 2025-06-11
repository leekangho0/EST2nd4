//
//  CalendarSection.swift
//  EST_Trip
//
//  Created by hyunMac on 6/9/25.
//

import Foundation

struct CalendarSection {
    // 해당 달력의 년,월
    let title: String
    // 해당 달의 날짜들 요소 모음
    let dates: [CalendarDate]
}

struct CalendarDate {
    let date: Date
    // 오늘, 다른일정
    let annotation: String?
}
