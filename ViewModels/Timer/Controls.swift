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
        if flowMode == .Custom {
            completeBlock()
        }
        else {
            
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
    }
    
    // Restart
    func Restart() {
        elapsedTime = 0
        if mode == .flowPaused {
            if flowMode == .Simple {
                setFlowTimeLeft(time: flowTime)
                setFlowStart()
            } else {
                setFlowTime(time: (flowList[selection].blocks[blocksCompleted].minutes * 60) + flowList[selection].blocks[blocksCompleted].seconds)
                setFlowStart()
            }
        }
        else if mode == .breakPaused || mode == .flowStart {
            setBreakTimeLeft(time: breakTime)
            setBreakStart()
        }
        else if mode == .breakStart {
            if flowMode == .Simple {
                setFlowTimeLeft(time: flowTime)
                setFlowStart()
                roundsCompleted = roundsCompleted - 1
            } else {
                blocksCompleted = blocksCompleted - 1
                setFlowTime(time: (flowList[selection].blocks[blocksCompleted].minutes * 60) + flowList[selection].blocks[blocksCompleted].seconds)
                setFlowStart()
            }
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
