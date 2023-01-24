//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    func endTimer() {
        invalidateTimer()
        elapsed = 0
        
        if Simple() {
            completeRound()
        } else {
            completeBlock()
        }
    }
    
    // Complete Round
    func completeRound() {
        if isFlow() {
            roundsCompleted += 1
            if roundsCompleted == roundsSet {
                completeSession()
            } else {
                mode = .breakStart
                if settings.startBreakAutomatically {
                    startBreak()
                }
            }
        }
        if isBreak() {
            setTimes(flowTime: flowTime, breakTime: breakTime)
            mode = .flowStart
            if settings.startFlowAutomatically {
                startFlow()
            }
        }
    }
    
    // Complete Block
    func completeBlock() {
        blocksCompleted += 1
        if blocksCompleted == flowList[selection].blocks.count {
            completeSession()
        }
        else {
            let block = flowList[selection].blocks[blocksCompleted]
            if block.flow {
                setFlowTime(time: (block.minutes * 60) + block.seconds)
                setFlowStart()
            } else {
                setBreakTime(time: (block.minutes * 60) + block.seconds)
                setBreakStart()
            }
        }
    }
    
    // Complete Session
    func completeSession() {
        mode = .Initial
        Initialize()
        elapsed = 0
        roundsCompleted = 0
        blocksCompleted = 0
        completed = true
    }
    
//     Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    func dismissCompleted() {
        totalTime = 0
        completed = false
    }
}
