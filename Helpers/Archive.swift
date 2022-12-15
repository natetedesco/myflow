//
//  Archive.swift
//  MyFlow
//  Created by Nate Tedesco on 12/13/22.
//

import Foundation

//func getLastSevenDaysArray() -> [Day] {
//    let components = calendar.dateComponents([.year, .month, .day], from: date)
//    let year =  components.year
//    let month = components.month
//    let day = components.day
//
//    var presentedDays: [Day] = []
//    var daysCounted = 0
//
//    for i in 0...6 {
//
//        if days.indices.contains(daysCounted) {
//            if days[daysCounted].day == Date.from(year: year!, month: month!,day: day! - i) {
//                presentedDays.append(days[daysCounted])
//                daysCounted = daysCounted + 1
//            }
//            else {
//                presentedDays.append(Day(day: Date.from(
//                    year: year!,
//                    month: month!,
//                    day: day! - i), time: 0))
//            }
//        }
//
//        else {
//            presentedDays.append(Day(day: Date.from(
//                year: year!,
//                month: month!,
//                day: day! - i), time: 0))
//        }
//    }
//    return presentedDays
//}
