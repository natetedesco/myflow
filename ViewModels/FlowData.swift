//
//  Day.swift
//  MyFlow
//  Created by Nate Tedesco on 12/12/22.
//

import SwiftUI
import Foundation

class FlowData: ObservableObject {
    var settings = Settings()
    
    @Published var showGoal = false

    @AppStorage("GoalMinutes") var goalMinutes: Double = 120
    @Published var days: [Day]
    
    var date = Date()
    var firstDayOfTheWeek = Date().startOfWeek()
    var firstDayOfMonth = Date().startOfMonth()
    
    let calendar = Calendar.current
    
    var todayTime: Int { getTodayTime() }
    var thisWeekTime: Int { getThisWeekTime() }
    var thisMonthTime: Int { getThisMonthTime() }
    
    var dayOfTheWeek: Int { getDayOfTheWeek() }
    var thisWeekDays: [Day] { getThisWeekDays() }
    var thisMonthDays: [Day] { getThisMonthDays() }
    
    init() {
        if settings.useDummyData {
            // Dummy Data
            date = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 15))!
            firstDayOfTheWeek = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 15))!.startOfWeek()
            firstDayOfMonth = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 15))!.startOfMonth()
            days = exampleDays
        } else {
            if let data = UserDefaults.standard.data(forKey: "SavedFlowData") {
                if let decoded = try? JSONDecoder().decode([Day].self, from: data) {
                    days = decoded
                    return
                }
            }
            days = []
        }
    }
    
    // Save
    func save() {
        if !settings.useDummyData {
            if let encoded = try? JSONEncoder().encode(days) {
                UserDefaults.standard.set(encoded, forKey: "SavedFlowData")
            }
        }
    }
    
    // Add time to today
    func addTime(time: Int) {
        if settings.multiplyTotalFlowTime {
            days[0].time = days[0].time + (time)
        } else {
            days[0].time = days[0].time + (time/60)
        }
        save()
    }
    
    // Create day struct
    func createDayStruct() {
        let comp = calendar.dateComponents([.year, .month, .day], from: date)
        
        //if day exists
        if days.indices.contains(0) {
            if days[0].day != Date.from(year: comp.year!, month: comp.month!, day: comp.day!) {
                days.insert(Day(
                    day: Date.from(year: comp.year!, month: comp.month!, day: comp.day!),
                    time: 0), at: 0)
                save()
            }
        } else {
            days.insert(Day(
                day: Date.from(year: comp.year!, month: comp.month!, day: comp.day!),
                time: 0), at: 0)
            save()
        }
    }
    
    // Get todays time
    func getTodayTime() -> Int {
        let comp = calendar.dateComponents([.year, .month, .day], from: date)
        var time = 0
        if days.indices.contains(0) {
            if days[0].day == Date.from(year: comp.year!, month: comp.month!, day: comp.day!) {
                time = days[0].time
            }
        }
        return time
    }
    
    // Get this weeks time
    func getThisWeekTime() -> Int {
        let comp = calendar.dateComponents([.year, .month, .day], from: firstDayOfTheWeek)
        var counted = 0
        var time = 0
        
        for i in 0...6 {
            if days.indices.contains(counted) {
                if days[counted].day == Date.from(year: comp.year!, month: comp.month!, day: (comp.day! + 6) - i) {
                    time = time + days[counted].time
                    counted = counted + 1
                }
            }
        }
        return time
    }
    
    // Get this months time
    func getThisMonthTime() -> Int {
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
    
    // Get this month days
    func getThisMonthDays() -> [Day] {
        let comp = calendar.dateComponents([.year, .month, .day], from: firstDayOfMonth)
        
        // This Month
        let diffInDays = Calendar.current.dateComponents([.day], from: firstDayOfMonth, to: date).day
        let numDays = Int(diffInDays!)
        var counted = 0
        
        var presentedDays: [Day] = []
        
        for i in 0...numDays {
            
            if days.indices.contains(counted) {
                if days[counted].day == Date.from(year: comp.year!, month: comp.month!, day: (comp.day! + numDays) - i) {
                    presentedDays.insert(days[counted], at: 0)
                    counted = counted + 1
                }
                else {
                    presentedDays.insert(Day(day: Date.from(year: comp.year!, month: comp.month!, day: comp.day! + numDays - i), time: 0), at: 0)
                }
            }
            else {
                presentedDays.insert(Day(day: Date.from(year: comp.year!, month: comp.month!, day: comp.day! + numDays - i), time: 0), at: 0)
            }
        }
        return presentedDays
    }
    
    // Get day of the week
    func getDayOfTheWeek() -> Int {
        var day = calendar.component(.weekday, from: date)
        if day != 1 {
            day = day - 1
        }
        else if day == 1 {
            day = 7
        }
        day = day - 1
        
        return day
    }
    
    func daysInCurrentMonth() -> Int {
        let calendar = Calendar.current
        let date = Date()
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        let numberOfDays = calendar.range(of: .day, in: .month, for: endOfMonth)?.count ?? 0
        
        return numberOfDays
    }
    
    var exampleDays: [Day] = [
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 15), time: 90),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 14), time: 130),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 13), time: 135),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 12), time: 85),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 11), time: 83),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 10), time: 135),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 9), time: 40),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 8), time: 80),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 7), time: 60),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 6), time: 100),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 5), time: 135),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 4), time: 185),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 3), time: 0),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 2), time: 135),
        Day(day: Date.from(
            year: Calendar.current.component(.year, from: Date()),
            month: Calendar.current.component(.month, from: Date()),
            day: 1), time: 170)
    ]
}

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
