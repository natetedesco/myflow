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
        startActivity(flow: flow, start: Date(), end: Date(), paused: true)
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
        if flowRunning() {
            setFlowTime(time: flowTime)
            setFlowStart()
            invalidateTimer()
        }
        else if breakRunning() {
            setBreakTimeLeft(time: breakTime)
            setBreakStart()
            invalidateTimer()
            
        }
        else {
            if blocksCompleted != 0 {
                
                blocksCompleted -= 1
                let block = flowList[selection].blocks[blocksCompleted]
                let time = (block.hours * 3600) + (block.minutes * 60) + (block.seconds)
                
                if block.flow {
                    type = .Flow
                    setFlowTime(time: time)
                    setFlowStart()
                }
                if !block.flow {
                    type = .Break
                    setBreakTime(time: time)
                    setBreakStart()
                    print(blocksCompleted)
                }
            }
        }
    }
    
    // Reset
    func Reset() {
        rigidHaptic()
        if isFlow() {
            if !flowContinue {
                addTime(time: flowTime - flowTimeLeft)
            }
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
        type = .Flow
        
        if flowContinue {
            start = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: start)!
        }
        mode = .flowRunning
        flowContinue = true
        startActivity(flow: true, start: start, end: start, extend: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            flowTimeLeft = (Calendar.current.dateComponents([.second], from: start, to: Date()).second ?? 0)
        }
    }
    
    // Complete Continue Flow
    func completeContinueFlow() {
        invalidateTimer()
        flowContinue = false
        addTime(time: flowTimeLeft)
        flowTimeLeft = flowTime
        elapsed = 0
        setNextBlock()
    }
}
