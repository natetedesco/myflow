//
//  FlowData.swift
//  MyFlow
//  Created by Nate Tedesco on 12/2/22.
//

import Foundation
import SwiftUI

struct Day: Identifiable, Equatable {
    let day: Date
    let time: Int
    var id: Date { day }
}

class FlowData: ObservableObject {
    let days: [Day] = [
        Day(day: Date.from(year: 2022, month: 12, day: 8), time: 1)
    ]
    var presentedDays: [Day] { getLastSevenDays() }
    
    func getLastSevenDays() -> [Day] {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        var presentedDays: [Day] = []
        var daysCounted = 0
        
        for i in 0...10 {
            
            if days.indices.contains(daysCounted) {
                
                if days[daysCounted].day == Date.from(
                    year: year!,
                    month: month!,
                    day: day! - i) {
                    presentedDays.append(days[daysCounted])
                    daysCounted = daysCounted + 1
                }
                else {
                    presentedDays.append(Day(day: Date.from(
                        year: year!,
                        month: month!,
                        day: day! - i), time: 0))
                }
            }
            
            else {
                presentedDays.append(Day(day: Date.from(
                    year: year!,
                    month: month!,
                    day: day! - i), time: 0))
            }
        }
        return presentedDays
    }
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        
        //        let now = Calendar.current.dateComponents(in: .current, from: Date())
        
        
        let components = DateComponents(year: year, month: month, day: day)
        
        return Calendar.current.date(from: components)!
        
    }
}

