//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func startInput() {
        if (flowTime > 0 && breakTime > 0) || flowMode == .Custom {
            mediumHaptic()
            switch mode {
            case .Initial: startFlow()
            case .flowStart: startFlow()
            case .flowPaused: flowContinue ? continueFlow() : startFlow()
            case .breakStart: startBreak()
            case .breakPaused: startBreak()
            case .flowRunning: pauseFlow()
            case .breakRunning: pauseBreak()
            }
        }
    }
    
    func startFlow() {
        setFlowRunning()
        startTimer(time: flowTime)
    }
    
    func startBreak() {
        setBreakRunning()
        startTimer(time: breakTime)
    }
    
    func pauseFlow() {
        mode = .flowPaused
        Pause()
    }
    
    func pauseBreak() {
        mode = .breakPaused
        Pause()
    }
}
