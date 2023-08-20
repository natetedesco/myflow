//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Complete Block
    func completeBlock() {
        blocksCompleted += 1
        if blocksCompleted == flowList[selection].blocks.count {
            completeSession()
        }
        else {
            setNextBlock()
        }
    }
    
    func setNextBlock() {
        let block = flowList[selection].blocks[blocksCompleted]
        if block.flow {
            setFlowTime(time: (block.minutes * 60) + block.seconds)
            setFlowStart()
        } else {
            setBreakTime(time: (block.minutes * 60) + block.seconds)
            setBreakStart()
        }
    }
    
    // Complete Session
    func completeSession() {
        mode = .Initial
        Initialize()
        elapsed = 0
        blocksCompleted = 0
        completed = true
    }
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    // Dismiss Completed
    func dismissCompleted() {
        totalTime = 0
        completed = false
    }
}
