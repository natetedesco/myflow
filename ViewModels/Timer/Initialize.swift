//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func Initialize() {
        let selection = flowList[selection]
        setFlowMode()
        
        // Initialize Simple
        if flowMode == .Simple {
            setFlowTime(time: selection.flowMinuteSelection)
            setBreakTime(time: selection.breakMinuteSelection)
            roundsRemaining = selection.roundsSelection // Add if rounds asp
        }
        
        // Initialize Custom
        if flowMode == .Custom {
            setBlock()
        }
    }
}
