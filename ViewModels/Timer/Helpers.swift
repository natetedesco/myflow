//
//  ElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    func getElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow)) // Gets time since start
        elapsedTime = elapsedTime + newTime // Adds total time from start
    }
    
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    func updateRounds() {
        self.roundsCompleted = roundsCompleted + 1
        self.roundsRemaining = roundsRemaining - 1
    }
    
}
