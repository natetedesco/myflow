//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Complete Round
    func completeRound() {
            if type == .Flow {
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
            else {
                setBothTimes(flowTime: flowTime, breakTime: breakTime)
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
