//
//  Skip:Restart.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    // Pause
    func Pause() {
        if !flowContinue {
            setElapsedTime()
        }
        invalidateTimer()
    }
    
    // Skip
    func Skip() {
        if type == .Flow {
            data.addTimeToDay(time: flowTime - flowTimeLeft)
            totalFlowTime = totalFlowTime + (flowTime - flowTimeLeft)
        }
        
        mode == .flowPaused ? setFlowTimeLeft(time: 0) : setBreakTimeLeft(time: 0)
        endTimer()
    }
    
    // Restart
    func Restart() {
        elapsedTime = 0
        mode == .flowPaused ? setFlowTimeLeft(time: flowTime) : setBreakTimeLeft(time: breakTime)
        mode == .flowPaused ? setFlowStart() : setBreakStart()
    }
    
    // Reset
    func Reset() {
        mediumHaptic()
        if type == .Flow {
            data.addTimeToDay(time: flowTime - flowTimeLeft)
            totalFlowTime = totalFlowTime + (flowTime - flowTimeLeft)
        }
        invalidateTimer()
        completeSession()
    }
    
    // Continue Flow
    func continueFlow() {
        mode = .flowRunning
        flowContinue = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            flowTimeLeft += 1
        })
    }
    
    // Complete Continue Flow
    func completeContinueFlow() {
        timer.invalidate()
        mode = .breakStart
        
        data.addTimeToDay(time: flowTimeLeft)
        flowTimeLeft = flowTime
        flowContinue = false
    }
}
