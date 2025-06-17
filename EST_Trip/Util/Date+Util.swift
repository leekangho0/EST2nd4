//
//  Date+Util.swift
//  EST_Trip
//
//  Created by kangho lee on 6/17/25.
//

import Foundation

extension Date {
    static func makeDateRange(from startDate: Date, to endDate: Date) -> [Date] {
        let calendar = Calendar.current
        
        guard startDate <= endDate else { return [] }
        
        var dates: [Date] = []
        var currentDate = calendar.startOfDay(for: startDate)
        let finalDate = calendar.startOfDay(for: endDate)
        
        while currentDate <= finalDate {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dates
    }
    
    static func range(start: Date, end: Date) -> String {
        "\(start.toString()) ~ \(end.toString(format: "MM.dd"))"
    }
}
