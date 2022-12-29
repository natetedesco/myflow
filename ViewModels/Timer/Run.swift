//
//  SimpleHelpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Run Timer
    func runTimer(time: Int, end: Date) {
        notifications.Set(flow: type == .Flow ? true : false, time: time, elapsedTime: elapsedTime)
        data.createDayStruct()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            totalFlowTime = totalFlowTime + 1

            countFlowTime()
            
            self.animate = animate + 1
            
            if getTimeLeft(end: end) == 0 {
                if flowMode == .Simple {
                    completeSimple()
                }
                if flowMode == .Custom {
                    completeCustom()
                }
            }
        })
    }
    
    func countFlowTime() {
        if totalFlowTime % 60 == 0 {
            data.addTimeToDay()
        }
    }
}
