//
//  Date+Extension.swift
//  EST_Trip
//
//  Created by 홍승아 on 6/17/25.
//

import Foundation

extension Date {
    func datesUntil(_ endDate: Date) -> [Date] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: self)
        let end = calendar.startOfDay(for: endDate)
        
        let dayCount = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        let range = dayCount >= 0 ? 0...dayCount : (dayCount...0)
        
        return range.map { offset in
            calendar.date(byAdding: .day, value: offset, to: start)!
        }
    }
}
