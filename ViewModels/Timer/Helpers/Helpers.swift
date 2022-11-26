//
//  Helpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    // Complete Session
    func completeSession() {
        completed = true
        Reset()
    }
    
}
