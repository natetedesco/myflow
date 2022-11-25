//
//  Complete.swift
//  MyFlow
//  Created by Nate Tedesco on 11/3/22.
//

import Foundation

extension FlowModel {
    
    func completeSimple(flow: Bool) {
        if flow {
            mode = completeRound() ? .Initial : .breakStart
        }
        if !flow {
            setTimes()
            mode = .flowStart
        }
    }
    
    func completeCustom() {
        blocksCompleted = blocksCompleted + 1

        if blocksCompleted == flowList[selection].blocks.count {
            mode = .Initial
            completed = true
            self.blocksCompleted = 0
        }
        
        else {
            blockTime = flowList[selection].blocks[blocksCompleted].timeSelection
            let flowBlock = flowList[selection].blocks[blocksCompleted].flow ? true : false
            setNextBlock(flow: flowBlock, time: blockTime)

        }
    }
    
}
