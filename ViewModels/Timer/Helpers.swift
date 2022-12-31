//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func setSimple() {
        flowMode = .Simple
    }
    func setCustom() {
        flowMode = .Custom
    }
    
    // Set Flow Time
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    // Set Break Time
    func setBreakTime(time: Int) {
        breakTime = time
        breakTimeLeft = time
    }
    
    // Set Flow Time Left
    func setFlowTimeLeft(time: Int) {
        flowTimeLeft = time
    }
    
    // Set Break Time Left
    func setBreakTimeLeft(time: Int) {
        breakTimeLeft = time
    }
    
    // Set Both
    func setBothTimes(flowTime: Int, breakTime: Int) {
        setFlowTime(time: flowTime)
        setBreakTime(time: breakTime)
    }
    
    // Set Elapsed Time
    func setElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsedTime = elapsedTime + newTime
    }
    
    // Get Mode
    func getMode() -> String {
        if flowList[selection].simple {
            return "simple"
        }
        return "custom"
    }
    
    // Start Automatically
    func ifStartAutomatically() {
        if type == .Break { // set initial values for labels(only break)
            if startFlowAutomatically { startFlow() }
        }
        if type == .Flow {
            if startBreakAutomatically { startBreak() }
        }
    }
    
    // Set Modes
    func setFlowStart() {
        mode = .flowStart
        type = .Flow
    }
    
    func setFlowRunning() {
        mode = .flowRunning
        type = .Flow
    }
    
    func setBreakRunning() {
        mode = .breakRunning
        type = .Break
    }
    
    func setBreakStart() {
        mode = .breakStart
        type = .Break
    }
}
