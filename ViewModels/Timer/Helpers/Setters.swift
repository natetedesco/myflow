//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    func setFlowMode() {
        if flowList[selection].simple {
            flowMode = .Simple
        }
        if !flowList[selection].simple {
            flowMode = .Custom
        }
    }
    
    // Set Flow Time
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    // Set Break Time
    func setBreakTime(time: Int) {
        breakTime = time
        breakTimeLeft = time
    }
    
    // Set Both
    func setBothTimes(flowTime: Int, breakTime: Int) {
        setFlowTime(time: flowTime)
        setBreakTime(time: breakTime)
    }
    
    // Set Elapsed Time
    func setElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsedTime = elapsedTime + newTime
    }
    
}
