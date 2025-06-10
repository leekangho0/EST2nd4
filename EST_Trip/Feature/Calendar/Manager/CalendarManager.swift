//
//  CalendarManager.swift
//  EST_Trip
//
//  Created by hyunMac on 6/9/25.
//

import Foundation

final class CalendarManager {
	// 2025.01~2030.12까지 담을 섹션
    private(set) var sections: [CalendarSection] = []
	// 뷰컨이 오늘 셀로 스크롤할 때 쓰는 인덱스
    private(set) var todayIndexPath: IndexPath?
    private let calendar = Calendar.current

    init() {
        generateSections()
    }

    func generateSections() {
        guard let start = DateComponents(calendar: calendar, year: 2025, month: 1, day: 1).date else {
            print("시작날짜 데이트 컴포넌트 생성 실패 오류")
            return
        }
        guard let end = DateComponents(calendar: calendar, year: 2030, month: 12, day: 1).date else {
            print("종료일 데이트 컴포넌트 생성 실패 오류")
            return
        }

        var monthCursor = start
        var sectionIdex = 0

        while monthCursor <= end {
            let comp = calendar.dateComponents([.year, .month], from: monthCursor)
            let year = comp.year
            let month = comp.month

            // 앞쪽 빈칸 계산
            guard let firstOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
                print("첫날 날짜 객체 생성 오류")
                return
            }

            let weekday = calendar.component(.weekday, from: firstOfMonth)
            let padding = weekday - 1
            
            let monthTitle = "\(year!)년 \(month!)월"

            // 필요한 일자 배열
            guard let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
                print("해당 달의 날짜 배열 생성 실패")
                return
            }
            var dates: [CalendarDate] = []

            dates.append(contentsOf: Array(repeating: CalendarDate(date: .distantPast, annotation: nil), count: padding))

            for day in range {
                guard let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
					print("달력 생성 오류, 레인지에 해당하는 일자 생성중 오류")
                    return
                }

                let annotation = calendar.isDateInToday(date) ? "오늘" : nil

                if annotation == "오늘" {
                    todayIndexPath = IndexPath(item: dates.count, section: sectionIdex)
                }

                dates.append(CalendarDate(date: date, annotation: annotation))
            }

            sections.append(CalendarSection(title: monthTitle, dates: dates))

            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: monthCursor) else {
                print("다음 달 계산 오류")
                return
            }
            monthCursor = nextMonth
            sectionIdex += 1
        }
    }

    var numberOfSections: Int {
        sections.count
    }

    func dates(for section: Int) -> [CalendarDate] {
        return sections[section].dates
    }

    func title(for section: Int) -> String {
        sections[section].title
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    func isWeekend(_ date: Date) -> Bool {
        let w = Calendar.current.component(.weekday, from: date)
        return w == 1 || w == 7
    }
}
