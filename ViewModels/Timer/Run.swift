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
}
