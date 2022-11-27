//
//  Getters.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Get Mode
    func getMode() -> String {
        if flowList[selection].simple {
            return "simple"
        }
        return "custom"
    }
    
    // Get End Time
    func getEnd(time: Int) -> Date {
        start = Date()
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .second, value: (time - elapsedTime), to: start)!
        
        return end
    }
    
    // Get Time Left
    func getTimeLeft(end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        self.animate = animate + 1
        
        if type == .Flow {
            flowTimeLeft = timeLeft
        }
        if type == .Break {
            breakTimeLeft = timeLeft
        }
        return timeLeft
    }
    
}
