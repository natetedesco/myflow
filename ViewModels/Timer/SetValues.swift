//
//  Setter.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import Foundation

extension FlowModel {
    
    func setValues() {
        simple = flowList[selection].customFlow ? false : true
        
        // Simple
        if simple {
            flowTime = flowList[selection].flowMinuteSelection
            breakTime = flowList[selection].breakMinuteSelection
            roundsCompleted = 0
            roundsRemaining = flowList[selection].roundsSelection
        }
        
        // Custom
        if !simple {
            setCustomValues()
        }
        
        // Both
        flowTimeLeft = flowTime
        breakTimeLeft = breakTime
        elapsedTime = 0
    }
    
    func setCustomValues() {
        blockTime = flowList[selection].blocks[0].timeSelection
        
        if flowList[selection].blocks[0].flow {
            flowTime = blockTime
            flowTimeLeft = blockTime
        }
        if !flowList[selection].blocks[0].flow {
            breakTime = blockTime
            breakTimeLeft = blockTime
        }
        
        self.blocksCompleted = 0
    }
}
