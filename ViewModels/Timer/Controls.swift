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
        startActivity(flow: flow, custom: flowMode == .Custom ? true : false, start: Date(), end: Date(), paused: true)
        stopRestrictions()
    }
    
    // Skip
    func Skip() {
        invalidateTimer()
        elapsed = 0
        if Simple() {
            if flowPaused() {
                mode = .breakStart
                breakTimeLeft = breakTime
                addTime(time: flowTime - flowTimeLeft)
                setFlowTimeLeft(time: 0)
                endTimer(skip: true)
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
        if flowContinue {
            start = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: start)!
        }
        mode = .flowRunning
        flowContinue = true
        startActivity(flow: true, custom: flowMode == .Custom ? true : false, start: start, end: start, extend: true)

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
        
        if Simple() {
            mode = .breakStart
        } else {
            setNextBlock()
        }
    }
}
