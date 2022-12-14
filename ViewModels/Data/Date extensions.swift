//
//  Date extensions.swift
//  MyFlow
//  Created by Nate Tedesco on 12/13/22.
//

import Foundation

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
    
    func startOfWeek(using calendar: Calendar = Calendar(identifier: .iso8601)) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    func startOfMonth(using calendar: Calendar = Calendar(identifier: .iso8601)) -> Date {
        calendar.dateComponents([.calendar, .year, .month], from: self).date!
    }
}
