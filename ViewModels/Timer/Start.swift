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
            Run(flow: true, time: flowTime)
            
        case .flowStart: mode = .flowRunning
            Run(flow: true, time: flowTime)
            
        case .breakStart: mode = .breakRunning
            Run(flow: false, time: breakTime)
            
        case .flowRunning: mode = .flowPaused
            Pause()
            
        case .breakRunning: mode = .breakPaused
            Pause()
            
        case .flowPaused: mode = .flowRunning
            Run(flow: true, time: flowTime)
            
        case .breakPaused: mode = .breakRunning
            Run(flow: false, time: breakTime)
            
        }
    }
}
