//
//  SimpleHelpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Start
    func Start() {
        if timesSet() {
            stopActivity()
            switch mode {
            case .Initial: Run(time: flowTime, flow: true)
            case .flowStart: Run(time: flowTime, flow: true)
            case .breakStart: Run(time: breakTime, flow: false)
            case .flowRunning: Pause(flow: true)
            case .breakRunning: Pause(flow: false)
            case .flowPaused: flowContinue ? continueFlow() : Run(time: flowTime, flow: true)
            case .breakPaused: Run(time: breakTime, flow: false)
            }
            createDay()
        }
    }
    
    // Run
    func Run(time: Int, flow: Bool) {
        setRunning(flow: flow)
        let end = setEnd(time: time)
        
        setSimpleNotification(flow: flow, time: time)
        startActivity(flow: flow, custom: flowMode == .Custom ? true : false, start: start, end: end)
        if settings.blockDistractions && flow == true { startRestriction() }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if timeLeft(end: end) <= 0 {
                if isFlow() {
                    setFlowTimeLeft(time: 0)
                    addTime(time: time)
                } else {
                    setBreakTimeLeft(time: 0)
                }
                endTimer()
            }
        }
    }
    
    // End
    func endTimer(skip: Bool = false) {
        invalidateTimer()
        stopActivity()
        stopRestrictions()
        elapsed = 0
        
        if Simple() {
            completeRound(skip: skip)
        } else {
            completeBlock()
        }
    }
}

