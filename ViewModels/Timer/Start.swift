//
//  TimerHelper.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    func Start() {
        mediumHaptic()
        
        switch mode {
            
        case .Initial: mode = .flowRunning
            Initialize(flow: true, time: flowTime)
            
        case .flowStart: mode = .flowRunning
            Initialize(flow: true, time: flowTime)
            
        case .breakStart: mode = .breakRunning
            Initialize(flow: false, time: breakTime)
            
        case .flowRunning: mode = .flowPaused
            Pause()
            
        case .breakRunning: mode = .breakPaused
            Pause()
            
        case .flowPaused: mode = .flowRunning
            Initialize(flow: true, time: flowTime)
            
        case .breakPaused: mode = .breakRunning
            Initialize(flow: false, time: breakTime)
            
        }
    }
}
