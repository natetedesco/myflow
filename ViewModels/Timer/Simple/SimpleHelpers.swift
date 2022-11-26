//
//  SimpleHelpers.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Run Timer
    func runTimer(time: Int, end: Date) {
        notifications.Set(
            flow: type == .Flow ? true : false,
            time: time,
            elapsedTime: elapsedTime)
        setMode(run: true)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            if getTimeLeft(end: end) == 0 {
                completeSimple()
            }
        })
    }
    
    // Complete Round
    func completeRound() -> Bool {
        if type == .Flow {
            self.roundsCompleted = roundsCompleted + 1
            self.roundsRemaining = roundsRemaining - 1
            
            if roundsCompleted == flowList[selection].roundsSelection {
                return true
            }
        }
        return false
    }
}
