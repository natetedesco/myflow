//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func Initialize() {
        let selection = flowList[selection]
        mode = .Initial
        setFlowMode()
        
        // Initialize Simple
        if flowMode == .Simple {
            setFlowTime(time: (selection.flowMinuteSelection * 60) + selection.flowSecondsSelection )
            setBreakTime(time: (selection.breakMinuteSelection * 60) + selection.breakSecondsSelection)
            roundsSet = selection.roundsSelection // Add if rounds asp
            totalFlowTime = (flowTime * roundsSet)
        }
        
        // Initialize Custom
        if flowMode == .Custom {
            mode = .Initial
            if selection.blocks.indices.contains(0) {
                if selection.blocks[0].flow {
                    setFlowTime(time: selection.blocks[0].minuteSelection)
                    type = .Flow
                }
                
                if !selection.blocks[0].flow {
                    setBreakTime(time: selection.blocks[0].minuteSelection)
                    mode = .breakStart
                    type = .Break
                }
            }
            else {
                setFlowTime(time: 0)
                type = .Flow
            }
        }
    }
}
