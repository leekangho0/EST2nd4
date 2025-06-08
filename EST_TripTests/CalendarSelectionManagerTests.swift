//
//  CalendarSelectionManagerTests.swift
//  EST_TripTests
//
//  Created by hyunMac on 6/8/25.
//

import XCTest
@testable import EST_Trip

final class CalendarSelectionManagerTests: XCTestCase {
    var manager: CalendarSelectionManager!

    override func setUp() {
        super.setUp()
        manager = CalendarSelectionManager()
    }

    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    func test_처음날짜선택하면_startDate가설정됨() {
        let today = Date()
        manager.select(date: today)
        XCTAssertEqual(manager.travelDate.startDate, today)
        XCTAssertNil(manager.travelDate.endDate)
    }

    func test_과거날짜를선택하면_Start와_End가스왑된다() {
        let later = Date()
        let earlier = Calendar.current.date(byAdding: .day, value: -5, to: later)!

        // 앞선 날짜 선택후 과거 날짜 눌렀을 경우
        manager.select(date: later)
        manager.select(date: earlier)

        // 과거 날짜는 스타트 데이트랑 일치해야하고, 미래는 엔드 데이트랑 일치해야함
        XCTAssertEqual(manager.travelDate.startDate, earlier)
        XCTAssertEqual(manager.travelDate.endDate, later)
    }

    func test_StartDAte를_다시선택하면_변화가없다() {
        let date = Date()
        manager.select(date: date)
        manager.select(date: date)
        XCTAssertEqual(manager.travelDate.startDate, date)
        XCTAssertNil(manager.travelDate.endDate)
    }

    func test_세번째로날짜를선택하면_start만새로_설정된다() {
        let first = Date()
        let second = Calendar.current.date(byAdding: .day, value: 2, to: first)!
        let third = Calendar.current.date(byAdding: .day, value: 1, to: first)!
        manager.select(date: first)
        manager.select(date: second)
        manager.select(date: third)
        XCTAssertEqual(manager.travelDate.startDate, third)
        XCTAssertNil(manager.travelDate.endDate)
    }

    func test_StartDate와_EndDate_중간의날짜를_판단한다() {
        let start = Date()
        let end = Calendar.current.date(byAdding: .day, value: 2, to: start)!
        let middle = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        manager.select(date: start)
        manager.select(date: end)
        XCTAssertTrue(manager.isInSelectedRange(middle))
    }

    func test_구간밖의날짜는_False를반환한다() {
        let start = Date()
        let end = Calendar.current.date(byAdding: .day, value: 2, to: start)!

        let outDateOfStart = Calendar.current.date(byAdding: .day, value: -1, to: start)!
		let outDateOfEnd = Calendar.current.date(byAdding: .day, value: 1, to: end)!

        XCTAssertFalse(manager.isInSelectedRange(outDateOfEnd))
        XCTAssertFalse(manager.isInSelectedRange(outDateOfStart))
    }

    func test_선택된날짜의_시작과_끝의경우_True를반환한다() {
        let start = Date()
        let end = Calendar.current.date(byAdding: .day, value: 2, to: start)!

        manager.select(date: start)
        manager.select(date: end)

        XCTAssertTrue(manager.isStartOrEndDate(start))
        XCTAssertTrue(manager.isStartOrEndDate(end))
    }
}
