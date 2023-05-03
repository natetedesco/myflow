//
//  StartAutomatically.swift
//  MyFlow
//  Created by Nate Tedesco on 1/26/23.
//

import Foundation

extension FlowModel {
    
    // if start both atomatically
    
    // figure out if in flow or break
    
    // take current time / Flow + Break
    
    // If the remainder is <= Flow then Flow
    
    // if the remainder is > Flow then Flow
    
    // Rounds would be equal to (total/Flow + Break) + 1
    
    func startFlowAutomatically(skip: Bool) {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        
        if settings.startFlowAutomatically {
            if newTime <= flowTime + breakTime {
                Run(time: (flowTime - (newTime - breakTime)), flow: true)
            } else {
                timer.invalidate()
            }
        }
    }
    
    func startBreakAutomatically(skip: Bool) {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        if settings.startBreakAutomatically {
            if skip {
                Run(time: breakTime, flow: false)
            } else {
                if newTime <= flowTime + breakTime {
                    Run(time: (breakTime - (newTime - flowTime)), flow: false)
                } else {
                    timer.invalidate()
                }
            }
        }
    }
}
