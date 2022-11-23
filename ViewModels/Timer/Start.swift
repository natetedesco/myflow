//
//  TimerHelper.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    func Start() {
        switch mode {
            
        // Start
        case .Initial: mode = .flowRunning
            initializeTimer(flow: true, time: flowTime)
            
        case .flowStart: mode = .flowRunning
            initializeTimer(flow: true, time: flowTime)
            
        case .breakStart: mode = .breakRunning
            initializeTimer(flow: false, time: breakTime)
            
        // Pause
        case .flowRunning: mode = .flowPaused
            Pause()
            
        case .breakRunning: mode = .breakPaused
            Pause()
            
        // Unpause
        case .flowPaused: mode = .flowRunning
            initializeTimer(flow: true, time: flowTime)
            
        case .breakPaused: mode = .breakRunning
            initializeTimer(flow: false, time: breakTime)
            
        }
        mediumHaptic()
    }
}
