//
//  Simple.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Start
    func startSimple(time: Int) {
        let end = getEnd(time: time)
        runTimer(time: time, end: end)
    }
    
    // Complete
    func completeSimple() {
        invalidateTimer()
        
        if completeRound() {
            completeSession()
        }
        else {
            setNextTimer()
        }
    }
    
    // Set Next Timer
    func setNextTimer() {
        elapsedTime = 0
        setMode(start: true)
        
        if type == .Break {
            setFlowTime(time: flowTime)
            setBreakTime(time: breakTime)
        }
    }
    
}
