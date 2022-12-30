//
//  Start.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func setSimple() {
        flowMode = .Simple
    }
    func setCustom() {
        flowMode = .Custom
    }
    
    func Initialize() {
        let selection = flowList[selection]
        elapsedTime = 0
        roundsCompleted = 0
        blocksCompleted = 0
        
        mode = .Initial
        selection.simple ? setSimple() : setCustom()
        
        // Initialize Simple
        if flowMode == .Simple {
            setFlowTime(time: (selection.flowMinutes * 60) + selection.flowSeconds )
            setBreakTime(time: (selection.breakMinutes * 60) + selection.breakSeconds)
            roundsSet = selection.rounds // Add if rounds asp
        }
        
        // Initialize Custom
        if flowMode == .Custom {
            mode = .Initial
            if selection.blocks.indices.contains(0) {
                if selection.blocks[0].flow {
                    setFlowTime(time: (selection.blocks[0].minutes * 60) + selection.blocks[0].seconds)
                    type = .Flow
                }
                
                if !selection.blocks[0].flow {
                    setBreakTime(time: (selection.blocks[0].minutes * 60) + selection.blocks[0].seconds)
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
