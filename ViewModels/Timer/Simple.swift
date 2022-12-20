//
//  Simple.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func completeContinueFlow() {
        timer.invalidate()
        flowContinue = false
        mode = .breakStart
    }
    
    func continueFlow() {
        mode = .flowRunning
        flowContinue = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            flowTimeLeft = flowTimeLeft + 1
            data.addTimeToDay()
        })
    }
    
    // Start
    func startSimple(time: Int) {
        let end = getEnd(time: time) // set end time
        runTimer(time: time, end: end) // run timer, set notification
    }
    
    // Complete
    func completeSimple() {
        invalidateTimer()
        
        if completeRound() { // complete round
            completeSession()
        }
        else {
            setNextTimer() // if not completed
        }
    }
    
    // Set Next
    func setNextTimer() {
        elapsedTime = 0 // reset elapsed time
        
        // set mode to flow or break start
        mode = type == .Flow ? .breakStart : .flowStart

        if type == .Break { // set initial values for labels(only break)
            setBothTimes(flowTime: flowTime, breakTime: breakTime)
        }
    }
}
