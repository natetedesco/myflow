//
//  Helpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Complete Round
    func completeRound() -> Bool {
        if type == .Flow {
            self.roundsCompleted = roundsCompleted + 1
            if roundsCompleted == flowList[selection].roundsSelection {
                return true
            }
        }
        return false
    }
    
    // Complete Block
    func completeBlock() -> Bool {
        blocksCompleted = blocksCompleted + 1
        if blocksCompleted == flowList[selection].blocks.count {
            return true
        }
        return false
    }
    
    // Complete Session
    func completeSession() {
        completed = true
    }
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
}
