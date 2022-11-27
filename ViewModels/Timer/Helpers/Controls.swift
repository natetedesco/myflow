//
//  Skip:Restart.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    // Pause
    func Pause(flow: Bool) {
        mode = flow ? .flowPaused : .breakPaused
        setElapsedTime()
        invalidateTimer()
    }
    
    // Skip
    func Skip() {
        if mode == .flowPaused {
            flowTimeLeft = 0
            completeSimple()
        }
        
        if mode == .breakPaused {
            breakTimeLeft = 0
            completeSimple()
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
        mediumHaptic()
        invalidateTimer()
        mode = .Initial
        elapsedTime = 0
        roundsCompleted = 0
        blocksCompleted = 0
        Initialize()
    }

}
