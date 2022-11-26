//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func Start() {
        mediumHaptic()
        
        switch mode {
            
            // Start Flow
        case .Initial, .flowStart, .flowPaused:
            Run(flow: true, time: flowTime)
            
            // Start Break
        case .breakStart, .breakPaused:
            Run(flow: false, time: breakTime)
            
            // Pause
        case .flowRunning, .breakRunning:
            Pause(flow: mode == .flowRunning ? true : false)
        }
    }
}
