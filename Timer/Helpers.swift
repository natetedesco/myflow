//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation
import SwiftUI

extension FlowModel {
    
    // Time Set?
    func timesSet() -> Bool {
        if (flowTime > 0) {
            return true
        }
        return false
    }
    
    // Create Day
    func createDay() {
        data.createDayStruct()
    }
    
    // Add Time
    func addTime(time: Int) {
        data.addTime(time: time)
        totalFlowTime = totalFlowTime + time
    }
    
    // Time Left
    func timeLeft(end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        setFlowTimeLeft(time: timeLeft)
        
        return timeLeft
    }
    
    // Set Notification
    func setNotification(time: Int, id: String = "timer") {
        notifications.Set(time: time, elapsed: elapsed, id: id)
    }
    
    // Set End
    func setEnd(time: Int) -> Date {
        start = Date()
        let end = Calendar.current.date(byAdding: .second, value: (time - elapsed), to: start)!
        return end
    }
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    // Dismiss Completed
    func dismissCompleted() {
        totalFlowTime = 0
    }
    
    // Set Flow Time
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    // Set Flow Time Left
    func setFlowTimeLeft(time: Int) {
        flowTimeLeft = time
    }
    
    // Set Elapsed Time
    func setElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsed = elapsed + newTime
    }
    
    func flowRunning() -> Bool {
        if mode == .flowRunning || mode == .flowPaused {
            return true
        }
        return false
    }
 
    func flowPaused() -> Bool {
        if mode == .flowPaused {
            return true
        }
        return false
    }
    
    
    func flowStart() -> Bool {
        if mode == .flowStart {
            return true
        }
        return false
    }
}

