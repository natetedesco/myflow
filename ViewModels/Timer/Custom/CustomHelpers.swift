//
//  CompleteRound.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func setBlock() {
        let flowBlock = flowList[selection].blocks[blocksCompleted].flow ? true : false
        blockTime = flowList[selection].blocks[blocksCompleted].timeSelection

        if flowBlock {
            setFlowTime(time: blockTime)
            mode = .flowStart
        }
        if !flowBlock {
            setBreakTime(time: blockTime)
            mode = .breakStart
        }
    }
    
    func completeBlock() -> Bool {
        blocksCompleted = blocksCompleted + 1
        
        if blocksCompleted == flowList[selection].blocks.count {
            return true
        }
        return false
    }
}
