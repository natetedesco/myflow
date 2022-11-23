//
//  Custom.swift
//  MyFlow
//  Created by Nate Tedesco on 11/7/22.
//

import Foundation

extension FlowModel {
    
    func completeCustom() {
        blocksCompleted = blocksCompleted + 1

        if blocksCompleted == flowList[selection].blocks.count {
            mode = .Initial
            completed = true
            self.blocksCompleted = 0
        }
        
        // if next block = flow
        else if flowList[selection].blocks[blocksCompleted].flow {
            blockTime = flowList[selection].blocks[blocksCompleted].timeSelection
            flowTime = blockTime
            flowTimeLeft = blockTime
            mode = .flowStart
        }
        
        else if !flowList[selection].blocks[blocksCompleted].flow {
            blockTime = flowList[selection].blocks[blocksCompleted].timeSelection
            breakTime = blockTime
            breakTimeLeft = blockTime
            mode = .breakStart
        }
        
    }
    
}
