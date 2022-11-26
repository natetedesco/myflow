//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    func initializeCustom() {
        setBlock()
    }
    
    // Run
    func runCustom(flow: Bool, time: Int) {
        let end = setTimer(flow: flow, time: time)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            if setTimeLeft(flow: flow, end: end) == 0 { // get time left
                completeCustom()
            }
        })
    }
    
    func completeCustom() {
        invalidateTimer()
        
        if completeBlock() {
            completeSession()
        }
        
        else {
            setBlock()
        }
    }
    
}

