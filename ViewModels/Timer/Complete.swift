//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Complete Round
    func completeRound() {
        mode = type == .Flow ? .breakStart : .flowStart
        
        if type == .Flow {
            roundsCompleted += 1
            if roundsCompleted == roundsSet {
                completeSession()
            }
        }
        else {
            setBothTimes(flowTime: flowTime, breakTime: breakTime)
        }
        ifStartAutomatically()
    }
    
    // Complete Block
    func completeBlock() {
        blocksCompleted += 1
        if blocksCompleted == flowList[selection].blocks.count {
            completeSession()
        }
        else {
            let block = flowList[selection].blocks[blocksCompleted]
            block.flow ? setFlowTime(time: (block.minutes * 60) + block.seconds) : setBreakTime(time: (block.minutes * 60) + block.seconds)
            
            block.flow ? setFlowStart() : setBreakStart()
        }
    }
    
    
    // Complete Session
    func completeSession() {
        Initialize()
        completed = true
    }
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    func dismissCompleted() {
        totalFlowTime = 0
        completed = false
    }
}
