//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    func setBreakTime(time: Int) {
        breakTime = time
        breakTimeLeft = time
    }
    
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    func completeSession() {
        completed = true
        Reset()
    }
    
    func getElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsedTime = elapsedTime + newTime
    }
    
    func setMode(
        flow: Bool,
        start: Bool = false,
        running: Bool = false,
        pause: Bool = false) {
            
        if start {
            if flow {
                mode = .breakStart
            }
            if !flow {
                mode = .flowStart
            }
        }
        
        if running {
            if flow {
                mode = .flowRunning
            }
            if !flow {
                mode = .breakRunning
            }
        }
    }
    
    func setTimeLeft(flow: Bool, end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        self.animate = animate + 1
        
        if flow {
            flowTimeLeft = timeLeft
        }
        if !flow {
            breakTimeLeft = timeLeft
        }
        return timeLeft
    }
}
