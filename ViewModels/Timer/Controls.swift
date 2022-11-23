//
//  Skip:Restart.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    // Pause
    func Pause() {
        timer.invalidate()
        getElapsedTime()
        notifications.removeAllPendingNotificationRequests()
    }
    
    // Skip
    func Skip() {
        if mode == .flowPaused {
            flowTimeLeft = 0
            
            Complete(flow: true)
        }
        if mode == .breakPaused {
            breakTimeLeft = 0
            
            Complete(flow: false)
        }
    }
    
    // Restart
    func Restart() {
        if mode == .flowPaused {
            flowTimeLeft = flowTime
            mode = .flowStart
        }
        if mode == .breakPaused {
            breakTimeLeft = breakTime
            mode = .breakStart
        }
        elapsedTime = 0
    }
    
    // Reset
    func Reset() {
        invalidateTimer()
        
        mode = .Initial
        
        setValues()
        
        mediumHaptic()
    }
}
