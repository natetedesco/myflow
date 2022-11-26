//
//  SimpleHelpers.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func runTimer(flow: Bool, end: Date) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            if setTimeLeft(flow: flow, end: end) == 0 {
                completeSimple(flow: flow)
            }
        })
    }
    
    func setTimer(flow: Bool, time: Int) -> Date {
        start = Date()
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .second, value: (time - elapsedTime), to: start)!
        
        notifications.Set(flow: flow, time: time, elapsedTime: elapsedTime)
        
        setMode(flow: flow, running: true)

        return end
    }
}
