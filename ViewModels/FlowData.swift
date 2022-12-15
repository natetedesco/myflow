//
//  Day.swift
//  MyFlow
//  Created by Nate Tedesco on 12/12/22.
//

import Foundation

class FlowData: ObservableObject {
    
    @Published var days: [Day] = [
        Day(day: Date.from(year: 2022, month: 12, day: 13), time: 10),
        Day(day: Date.from(year: 2022, month: 12, day: 12), time: 10)
    ]
    
    let date = Date()
    let firstDayOfTheWeek = Date().startOfWeek()
    let calendar = Calendar.current
    
    var todayTime: Int { getTodayTime() }
    var thisWeekTime: Int { getThisWeekTime() }
    var thisMonthTime: Int { getThisMonthTime() }
    
    var thisWeekDays: [Day] { getThisWeekDays() }
    var dayOfTheWeek: Int { getDayOfTheWeek() }
    
    func createDayStruct() {
        //if day exists
        
        // if day doesn't exist
        let comp = calendar.dateComponents([.year, .month, .day], from: date)
        days.insert(Day(
            day: Date.from(year: comp.year!, month: comp.month!, day: comp.day!),
            time: 1), at: 0)
    }
    
    func addTimeToDay(time: Int) {
        days[0].time = time
    }
    
    func getTodayTime() -> Int {
        let comp = calendar.dateComponents([.year, .month, .day], from: date)
        var time = 0
        if days[0].day == Date.from(year: comp.year!, month: comp.month!, day: comp.day!) {
            time = days[0].time
        }
        return time
    }
    
    func getThisWeekTime() -> Int {
        let comp = calendar.dateComponents([.year, .month, .day], from: firstDayOfTheWeek)
        var counted = 0
        var weekTime = 0
        
        for i in 0...6 {
            if days.indices.contains(counted) {
                if days[counted].day == Date.from(year: comp.year!, month: comp.month!, day: (comp.day! + 6) - i) {
                    weekTime = weekTime + days[counted].time
                    counted = counted + 1
                }
            }
        }
        return weekTime
    }
    
    func getThisWeekDays() -> [Day] {
        let comp = calendar.dateComponents([.year, .month, .day], from: firstDayOfTheWeek)
        var counted = 0
        var presentedDays: [Day] = []
        
        for i in 0...6 {
            if days.indices.contains(counted) {
                if days[counted].day == Date.from(year: comp.year!, month: comp.month!, day: (comp.day! + 6) - i) {
                    presentedDays.insert(days[counted], at: 0)
                    counted = counted + 1
                }
                else {
                    presentedDays.insert(Day(day: Date.from(year: comp.year!, month: comp.month!, day: comp.day! + 6 - i), time: 0), at: 0)
                }
            }
            else {
                presentedDays.insert(Day(day: Date.from(year: comp.year!, month: comp.month!, day: comp.day! + 6 - i), time: 0), at: 0)
            }
        }
        return presentedDays
    }
    
    func getThisMonthTime() -> Int {
        let firstDayOfMonth = Date().startOfMonth()
        let comp = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        var counted = 0
        var time = 0
        
        for i in 0...30 {
            if days.indices.contains(i) {
                if calendar.isDate(days[counted].day, equalTo: Date.from(year: comp.year!, month: comp.month!, day: comp.day!), toGranularity: .month) {
                    time = time + days[counted].time
                    counted = counted + 1
                }
            }
        }
        return time
    }
}