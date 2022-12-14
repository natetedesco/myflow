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
    var today: Bool = false
    var id: Date { day }
}

//    let date = Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 11))!
//    let firstDayOfTheWeek = Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 5))!
