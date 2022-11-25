//
//  Complete.swift
//  MyFlow
//  Created by Nate Tedesco on 11/3/22.
//

import Foundation

extension FlowModel {
    
    func completeFlow() {
        if completeRound() {
            completeSession()
        }
        else {
            mode = .breakStart
        }
    }
    
    func completeBreak() {
        flowTimeLeft = flowTime
        breakTimeLeft = breakTime
        elapsedTime = 0
        mode = .flowStart
    }
    
    func completeBlock() {
        blocksCompleted = blocksCompleted + 1
        
        if blocksCompleted == flowList[selection].blocks.count {
            completeSession()
        }
        
        else {
            let flowBlock = flowList[selection].blocks[blocksCompleted].flow ? true : false
            setNextBlock(flow: flowBlock)
            
        }
    }
    
    func completeSession() {
        setValues()
        completed = true
        mode = .Initial
        self.blocksCompleted = 0
    }
}
