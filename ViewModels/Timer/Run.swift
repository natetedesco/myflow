//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    // Initialize
    func initializeTimer(flow: Bool, time: Int) {
        start = Date()
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .second, value: (time - elapsedTime), to: start)!
        
        notifications.Set(flow: flow, time: time, elapsedTime: elapsedTime)
        
        Run(flow: flow, end: end)
    }
    
    // Run
    func Run(flow: Bool, end: Date) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            
            let timeLeft = setTimeLeft(flow: flow, end: end)
            
            if timeLeft == 0 {
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
            completeCustom()
        }
    }
}
