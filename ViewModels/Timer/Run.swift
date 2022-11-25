//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Initialize
    func Run(flow: Bool, time: Int) {
        let end = setEndTime(time: time)
        notifications.Set(flow: flow, time: time, elapsedTime: elapsedTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            if setTimeLeft(flow: flow, end: end) == 0 {
                Complete(flow: flow)
            }
        })
    }
    
    // Complete
    func Complete(flow: Bool) {
        invalidateTimer()
        
        if simple {
            completeSimple(flow: flow)
        }
        if !simple {
            completeBlock()
        }
    }
}

