//
//  SetNextBlock.swift
//  MyFlow
//  Created by Nate Tedesco on 11/24/22.
//

import Foundation

extension FlowModel {
    
    func setNextBlock(flow: Bool) {
        blockTime = flowList[selection].blocks[blocksCompleted].timeSelection

        if flow {
            flowTime = blockTime
            flowTimeLeft = blockTime
            mode = .flowStart
        }
        if !flow {
            breakTime = blockTime
            breakTimeLeft = blockTime
            mode = .breakStart
        }
    }
}
