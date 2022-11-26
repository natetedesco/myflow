//
//  Simple.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func Initialize() {
        setFlowTime(time: flowList[selection].flowMinuteSelection)
        setBreakTime(time: flowList[selection].breakMinuteSelection)
        roundsRemaining = flowList[selection].roundsSelection
    }
    
    func Run(flow: Bool, time: Int) {
        let end = setTimer(flow: flow, time: time)
        
        runTimer(flow: flow, end: end)
    }
    
    func completeSimple(flow: Bool) {
        invalidateTimer()
        
        if completeRound(flow: flow) {
            completeSession()
        }
        else {
            setNextTimer(flow: flow)
        }
    }
    
    func completeRound(flow: Bool) -> Bool {
        if flow {
            self.roundsCompleted = roundsCompleted + 1
            self.roundsRemaining = roundsRemaining - 1
            
            if roundsCompleted == flowList[selection].roundsSelection {
                return true
            }
        }
        return false
    }
    
    func setNextTimer(flow: Bool) {
        elapsedTime = 0
        setMode(flow: flow, start: true)
        
        if !flow {
            setFlowTime(time: flowTime)
            setBreakTime(time: breakTime)
        }
    }
}
