//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Start
    func startCustom(time: Int) {
        let end = getEnd(time: time) // set end time
        runTimer(time: time, end: end) // run timer, set notification
    }
    
    // Complete
    func completeCustom() {
        invalidateTimer()
        
        if completeBlock() {
            completeSession()
        }
        else {
            setBlock()
        }
    }
    
    // set Next
    func setBlock() {
        elapsedTime = 0 // reset elapsed time
        let flowBlock = flowList[selection].blocks[blocksCompleted].flow ? true : false
        let blockTime = flowList[selection].blocks[blocksCompleted].minuteSelection

        if flowBlock {
            setFlowTime(time: blockTime)
            mode = .flowStart
            type = .Flow
        }
        if !flowBlock {
            setBreakTime(time: blockTime)
            mode = .breakStart
            type = .Break
        }
    }
}
