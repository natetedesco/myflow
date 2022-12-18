//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func Initialize() {
        let selection = flowList[selection]
//        let block = selection.blocks[blocksCompleted]
        mode = .Initial
        setFlowMode()
        
        // Initialize Simple
        if flowMode == .Simple {
            setFlowTime(time: selection.flowMinuteSelection)
            setBreakTime(time: selection.breakMinuteSelection)
            roundsSet = selection.roundsSelection // Add if rounds asp
        }
        
        // Initialize Custom
        if flowMode == .Custom {
            mode = .Initial
            if selection.blocks[0].flow {
                setFlowTime(time: selection.flowMinuteSelection)
                type = .Flow
            }
            
            if !selection.blocks[0].flow {
                setBreakTime(time: blockTime)
                mode = .breakStart
                type = .Break
            }
        }
    }
}
