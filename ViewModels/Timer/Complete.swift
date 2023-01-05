//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Start Automatically
    func startAutomatically() -> Bool {
        if type == .Break { // set initial values for labels(only break)
            if settings.startFlowAutomatically {
                startFlow()
                return true
            }
        }
        if type == .Flow {
            if settings.startBreakAutomatically {
                startBreak()
                return true
            }
        }
        return false
    }
    
    
    // Complete Round
    func completeRound() {
            if type == .Flow {
                roundsCompleted += 1
                if roundsCompleted == roundsSet {
                    completeSession()
                }
            }
            else {
                setBothTimes(flowTime: flowTime, breakTime: breakTime)
            }
        if !startAutomatically() {
            mode = type == .Flow ? .breakStart : .flowStart
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
