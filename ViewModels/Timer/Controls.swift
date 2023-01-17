//
//  Skip:Restart.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    // Pause
    func Pause() {
        setElapsedTime()
        invalidateTimer()
    }
    
    // Skip
    func Skip() {
        if mode == .breakStart {
            mode = .flowStart
            flowTimeLeft = flowTime
        }
        else {
            if type == .Flow {
                data.addTimeToDay(time: flowTime - flowTimeLeft)
                totalFlowTime = totalFlowTime + (flowTime - flowTimeLeft)
            }
            mode == .flowPaused ? setFlowTimeLeft(time: 0) : setBreakTimeLeft(time: 0)
            endTimer()
        }
    }
    
    // Restart
    func Restart() {
        elapsedTime = 0
        if mode == .flowPaused {
            setFlowTimeLeft(time: flowTime)
            setFlowStart()
        }
        if mode == .breakPaused || mode == .flowStart {
            setBreakTimeLeft(time: breakTime)
            setBreakStart()
        }
        if mode == .breakStart {
            setFlowTimeLeft(time: flowTime)
            setFlowStart()
            roundsCompleted = roundsCompleted - 1
        }
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
        var startDate = Date()
        if flowContinue {
            startDate = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: startDate)!
        }
        mode = .flowRunning
        flowContinue = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            flowTimeLeft = (Calendar.current.dateComponents([.second], from: startDate, to: Date()).second ?? 0)
        })
    }
    
    // Complete Continue Flow
    func completeContinueFlow() {
        timer.invalidate()
        mode = .breakStart
        data.addTimeToDay(time: flowTimeLeft)
        totalFlowTime = totalFlowTime + flowTimeLeft
        flowTimeLeft = flowTime
        flowContinue = false
    }
}
