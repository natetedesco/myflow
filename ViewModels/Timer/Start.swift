//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func Initialize() {
        setFlow()
        setMode()
        
        if flowMode == .Simple {
            setSimpleFlow()
        }
        if flowMode == .Custom {
            if flow.blocks.indices.contains(0) {
                if flow.blocks[0].flow {
                    setFlowTime(time: (flow.blocks[0].minutes * 60) + flow.blocks[0].seconds)
                    type = .Flow
                }
                else {
                    setBreakTime(time: 0)
                }
            }
            else {
                setFlowTime(time: 0)
                type = .Flow
            }
        }
        elapsedTime = 0
        roundsCompleted = 0
        blocksCompleted = 0
    }
    
    func startInput() {
        if (flowTime > 0 && breakTime > 0) ||
            (flowMode == .Custom && (flowTime > 0 || breakTime > 0)) {
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
        startTimer(time: flowTime)
        type = .Flow
        mode = .flowRunning
    }
    
    func startBreak() {
        startTimer(time: breakTime)
        mode = .breakRunning
        type = .Break
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
