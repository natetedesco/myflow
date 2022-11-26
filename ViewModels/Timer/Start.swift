//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func startInput() {
        mediumHaptic()
        
        if flowMode == .Simple {
            switch mode {
                // Start Flow
                
            case .Initial, .flowStart, .flowPaused:
                startSimple(time: flowTime)
                type = .Flow
                
                // Start Break
            case .breakStart, .breakPaused:
                startSimple(time: breakTime)
                type = .Break

                // Pause
            case .flowRunning, .breakRunning:
                Pause(flow: mode == .flowRunning ? true : false)
            }
        }
    }
    
}
