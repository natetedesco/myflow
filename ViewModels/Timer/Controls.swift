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
    
    // find way to early return here
    func Skip() {
        if Simple() {
            if flowPaused() {
                mode = .breakStart
                addTime(time: flowTime - flowTimeLeft)
                setFlowTimeLeft(time: 0)
                endTimer()
            }
            else if breakStart() || breakPaused() {
                mode = .flowStart
                flowTimeLeft = flowTime
            }
        }
        if Custom() {
            endTimer()
        }
    }
    
    // Restart
    func Restart() {
        elapsed = 0
        if flowPaused() {
            if Simple() {
                setFlowTimeLeft(time: flowTime)
                setFlowStart()
            }
            if Custom() {
                setFlowTime(time: (flowList[selection].blocks[blocksCompleted].minutes * 60) + flowList[selection].blocks[blocksCompleted].seconds)
                setFlowStart()
            }
        }
        else if breakPaused() || flowStart() {
            setBreakTimeLeft(time: breakTime)
            setBreakStart()
        }
        else if breakStart() {
            if Simple() {
                setFlowTimeLeft(time: flowTime)
                setFlowStart()
                roundsCompleted -= 1
            }
            if Custom() {
                blocksCompleted -= 1
                setFlowTime(time: (flowList[selection].blocks[blocksCompleted].minutes * 60) + flowList[selection].blocks[blocksCompleted].seconds)
                setFlowStart()
            }
        }
    }
    
    // Reset
    func Reset() {
        mediumHaptic()
        if isFlow() {
            addTime(time: flowTime - flowTimeLeft)
        }
        invalidateTimer()
        completeSession()
    }
    
    // Continue Flow
    func continueFlow() {
        var start = Date()
        if flowContinue {
            start = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: start)!
        }
        mode = .flowRunning
        flowContinue = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            flowTimeLeft = (Calendar.current.dateComponents([.second], from: start, to: Date()).second ?? 0)
        }
    }
    
    // Complete Continue Flow
    func completeContinueFlow() {
        invalidateTimer()
        mode = .breakStart
        addTime(time: flowTimeLeft)
        flowTimeLeft = flowTime
        flowContinue = false
        elapsed = 0
    }
}
