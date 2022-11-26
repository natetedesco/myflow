//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Run
    func startCustom(flow: Bool, time: Int) {
        let end = getEnd(time: time)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            if getTimeLeft(end: end) == 0 { // get time left
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

