//
//  Skip:Restart.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    // Pause
    func Pause(flow: Bool) {
        mode = .flowPaused
        setElapsedTime()
        invalidateTimer()

        stopRestrictions()
    }
    
    // Skip
    func Skip() {
        elapsed = 0
        endTimer()
    }
    
    // Restart
    func Restart() {
        elapsed = 0
        mode = .flowStart
        if flowRunning() {
            setFlowTime(time: flowTime)
            invalidateTimer()
        } else {
            if blocksCompleted != 0 {
                
                blocksCompleted -= 1
                let block = flow.blocks[blocksCompleted]
                let time = (block.hours * 3600) + (block.minutes * 60) + (block.seconds)
                    setFlowTime(time: time)
            }
        }
    }
    
    // Reset
    func Reset() {
        rigidHaptic()
            if !flowContinue {
                addTime(time: flowTime - flowTimeLeft)
            }
        invalidateTimer()
        stopActivity()
        completeSession()
        stopRestrictions()
        flowContinue = false
    }
    
    // Continue Flow
    func continueFlow() {
        var start = Date()
        
        if flowContinue {
            start = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: start)!
        }
        mode = .flowRunning
        flowContinue = true
        if settings.liveActivities {
            startActivity(start: start, end: start, extend: true)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            flowTimeLeft = (Calendar.current.dateComponents([.second], from: start, to: Date()).second ?? 0)
        }
    }
    
    // Complete Continue Flow
    func completeContinueFlow() {
        invalidateTimer()
        addTime(time: flowTimeLeft)
        
        flowContinue = false
        flowTimeLeft = flowTime
        elapsed = 0
        
        blocksCompleted = blocksCompleted - 1
        completeBlock()
    }
    
    func completeSession() {
        showFlow = false
//        showFlowRunning = false
        mode = .initial
        elapsed = 0
        blocksCompleted = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showFlowCompleted  = true
            print("completed")
        }
        Initialize()
    }
}
