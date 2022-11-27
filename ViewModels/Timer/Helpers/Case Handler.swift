//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func startInput() {
        switch mode {
            
        case .Initial:
            startFlowRunning()
            
        case .flowStart:
            startFlowRunning()
            
        case .flowPaused:
            startFlowRunning()
            
        case .breakStart:
            startBreakrunning()
            
        case .breakPaused:
            startBreakrunning()
            
        case .flowRunning:
            pauseFlow()
            
        case .breakRunning:
            pauseBreak()
            
        }
    }
    
    func Start(time: Int) {
        if flowMode == .Simple {
            startSimple(time: time)
        }
        
        if flowMode == .Custom {
            startCustom(time: time)
        }
        
    }
    
    func startFlowRunning() {
        mediumHaptic()
        mode = .flowRunning
        type = .Flow
        Start(time: flowTime)
    }
    
    func startBreakrunning() {
        mediumHaptic()
        mode = .breakRunning
        type = .Break
        Start(time: breakTime)
    }
    
    func pauseFlow() {
        mediumHaptic()
        mode = .flowPaused
        Pause(flow: mode == .flowRunning ? true : false)
    }
    
    func pauseBreak() {
        mediumHaptic()
        mode = .breakPaused
        Pause(flow: mode == .flowRunning ? true : false)
    }
    
    func setStartMode() {
        if type == .Flow {
            mode = .breakStart
        }
        if type == .Break {
            mode = .flowStart
        }
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
