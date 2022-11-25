//
//  InvalidateTimer.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func invalidateTimer() {
        
        timer.invalidate()
        
        notifications.removeAllPendingNotificationRequests()
    }
    
}
