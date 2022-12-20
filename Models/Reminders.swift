//
//  Reminder.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation

struct DayReminder: Identifiable {
    var id = UUID()
    var day: String
    var isOn: Bool
}

class Reminders: ObservableObject {
    @Published var days = [
        DayReminder(day: "M", isOn: false),
        DayReminder(day: "T", isOn: false),
        DayReminder(day: "W", isOn: false),
        DayReminder(day: "T", isOn: false),
        DayReminder(day: "F", isOn: false),
        DayReminder(day: "S", isOn: false),
        DayReminder(day: "S", isOn: false)
    ]
}
