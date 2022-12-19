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
                FlowRunning()
                
            case .flowStart:
                FlowRunning()
                
            case .flowPaused:
                FlowRunning()
                
            case .breakStart:
                Breakrunning()
                
            case .breakPaused:
                Breakrunning()
                
            case .flowRunning:
                pauseFlow()
                
            case .breakRunning:
                pauseBreak()
            }
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
    
    func FlowRunning() {
        mode = .flowRunning
        type = .Flow
        Start(time: flowTime)
    }
    
    func Breakrunning() {
        mode = .breakRunning
        type = .Break
        Start(time: breakTime)
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
