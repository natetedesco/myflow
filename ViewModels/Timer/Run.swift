//
//  SimpleHelpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Start
    func startTimer(time: Int) {
        start = Date()
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .second, value: (time - elapsedTime), to: start)!
        
        runTimer(time: time, end: end)
    }
    
    // Run Timer
    func runTimer(time: Int, end: Date) {
        notifications.Set(flow: type == .Flow ? true : false, time: time, elapsedTime: elapsedTime)
        data.createDayStruct()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            var timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
            type == .Flow ? setFlowTimeLeft(time: timeLeft) : setBreakTimeLeft(time: timeLeft)
            
            if timeLeft <= 0 {
                timeLeft = 0
                type == .Flow ? setFlowTimeLeft(time: timeLeft) : setBreakTimeLeft(time: timeLeft)
                if type == .Flow {
                    data.addTimeToDay(time: time)
                    totalFlowTime = totalFlowTime + time
                }
                endTimer()
            }
        })
    }
    
    // End Timer
    func endTimer() {
        invalidateTimer()
        elapsedTime = 0
        
        flowMode == .Simple ? completeRound() : completeBlock()
    }
}
