//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func setFlow() {
        if flowList.count != 0 {
            self.flow = flowList[selection]
        } else {
            self.flow = Flow(new: true, title: "Flow")
        }
    }
    
    func setMode() {
        if flow.simple {
            flowMode = .Simple
        } else {
            flowMode = .Custom
        }
    }
    
    func setSimpleFlow() {
        setFlowTime(time: (flow.flowMinutes * 60) + flow.flowSeconds )
        setBreakTime(time: (flow.breakMinutes * 60) + flow.breakSeconds)
        roundsSet = flow.rounds // Add if rounds asp
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
            if settings.startFlowAutomatically { startFlow() }
        }
        if type == .Flow {
            if settings.startBreakAutomatically { startBreak() }
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
