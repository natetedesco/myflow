//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func setFlowMode() {
        if flowList[selection].simple {
            flowMode = .Simple
        }
        if !flowList[selection].simple {
            flowMode = .Custom
        }
        
    }
    
    // Set Flow Time
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    // Set Break Time
    func setBreakTime(time: Int) {
        breakTime = time
        breakTimeLeft = time
    }
    
    // Set Elapsed Time
    func setElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsedTime = elapsedTime + newTime
    }
    
    // Set Mode
    func setMode(
        start: Bool = false,
        run: Bool = false,
        pause: Bool = false) {
            
        if start {
            if type == .Flow {
                mode = .breakStart
            }
            if type == .Break {
                mode = .flowStart
            }
        }
        
        if run {
            if type == .Flow {
                mode = .flowRunning
            }
            if type == .Break {
                mode = .breakRunning
            }
        }
    }
}
