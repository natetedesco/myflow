//
//  Day.swift
//  MyFlow
//  Created by Nate Tedesco on 12/12/22.
//

import Foundation

class FlowData: ObservableObject {
    init() {
        if let data = UserDefaults.standard.data(forKey: "SavedFlowData") {
            if let decoded = try? JSONDecoder().decode([Day].self, from: data) {
                days = decoded
                return
            }
        }
        days = [
            Day(day: Date.from(year: 2022, month: 12, day: 15), time: 90),
            Day(day: Date.from(year: 2022, month: 12, day: 14), time: 140),
            Day(day: Date.from(year: 2022, month: 12, day: 13), time: 100),
            Day(day: Date.from(year: 2022, month: 12, day: 12), time: 100),
            Day(day: Date.from(year: 2022, month: 12, day: 11), time: 120),
            Day(day: Date.from(year: 2022, month: 12, day: 10), time: 60),
            Day(day: Date.from(year: 2022, month: 12, day: 9), time: 80),
            Day(day: Date.from(year: 2022, month: 12, day: 8), time: 100),
            Day(day: Date.from(year: 2022, month: 12, day: 7), time: 120),
            Day(day: Date.from(year: 2022, month: 12, day: 6), time: 140),
            Day(day: Date.from(year: 2022, month: 12, day: 5), time: 90),
            Day(day: Date.from(year: 2022, month: 12, day: 4), time: 70),
            Day(day: Date.from(year: 2022, month: 12, day: 3), time: 80),
            Day(day: Date.from(year: 2022, month: 12, day: 1), time: 60),
        ]
    }
    
    @Published var days: [Day] = []
    
    let date = Date()
    let firstDayOfTheWeek = Date().startOfWeek()
    let calendar = Calendar.current
    
    var todayTime: Int { getTodayTime() }
    var thisWeekTime: Int { getThisWeekTime() }
    var thisMonthTime: Int { getThisMonthTime() }
    
    var dayOfTheWeek: Int { getDayOfTheWeek() }
    var thisWeekDays: [Day] { getThisWeekDays() }
    var thisMonthDays: [Day] { getThisMonthDays() }
    
    // Get this month days
    func getThisMonthDays() -> [Day] {
        let firstDayOfMonth = Date().startOfMonth()
        let comp = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        let date = calendar.date(from: comp)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        var counted = 0
        
        var presentedDays: [Day] = []
        
        for i in 0...numDays {
            // Add if day is less than or equal to today
            
            if days.indices.contains(counted) {
                if days[counted].day == Date.from(year: comp.year!, month: comp.month!, day: (comp.day! + numDays) - i) {
                    presentedDays.insert(days[counted], at: 0)
                    counted = counted + 1
                }
            }
            else {
                presentedDays.insert(Day(day: Date.from(year: comp.year!, month: comp.month!, day: comp.day! + numDays - i), time: 0), at: 0)
            }
        }
        return presentedDays
    }
    
    // Save
    func save() {
        if let encoded = try? JSONEncoder().encode(days) {
            UserDefaults.standard.set(encoded, forKey: "SavedFlowData")
        }
    }
    
    // Add time to today
    func addTimeToDay(time: Int) {
        days[0].time = days[0].time + (time)
        save()
    }
    
    // Create day struct
    func createDayStruct() {
        let comp = calendar.dateComponents([.year, .month, .day], from: date)
        
        //if day exists
        if days[0].day != Date.from(year: comp.year!, month: comp.month!, day: comp.day!) {
            days.insert(Day(
                day: Date.from(year: comp.year!, month: comp.month!, day: comp.day!),
                time: 1), at: 0)
            save()
        }
    }
    
    // Get todays time
    func getTodayTime() -> Int {
        let comp = calendar.dateComponents([.year, .month, .day], from: date)
        var time = 0
        if days[0].day == Date.from(year: comp.year!, month: comp.month!, day: comp.day!) {
            time = days[0].time
        }
        return time
    }
    
    // Get this weeks time
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
    
    // Get this weeks days
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
    
    // Get this months time
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
