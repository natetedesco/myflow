//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func startInput() {
        if flowTime > 0 && breakTime > 0 {
            mediumHaptic()
            
            switch mode {
            case .Initial:
                startFlow()
                
            case .flowStart:
                startFlow()
                
            case .flowPaused:
                if flowContinue {
                    continueFlow()
                }
                else {
                    startFlow()
                }
                
            case .breakStart:
                startBreak()
                
            case .breakPaused:
                startBreak()
                
            case .flowRunning:
                pauseFlow()
                
            case .breakRunning:
                pauseBreak()
            }
        }
    }
    
    func startFlow() {
        mode = .flowRunning
        type = .Flow
        Start(time: flowTime)
    }
    
    func startBreak() {
        mode = .breakRunning
        type = .Break
        Start(time: breakTime)
    }
    
    func Start(time: Int) {
        if flowMode == .Simple {
            startSimple(time: time)
        }
        if flowMode == .Custom {
            startCustom(time: time)
        }
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

enum FlowType {
    case Flow
    case Break
}

enum FlowMode {
    case Simple
    case Custom
}

enum TimerMode {
    case Initial
    case flowStart
    case flowRunning
    case flowPaused
    case breakStart
    case breakRunning
    case breakPaused
}
