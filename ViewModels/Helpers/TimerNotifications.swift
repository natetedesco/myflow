//
//  timerNotifications.swift
//  MyFlow
//  Created by Nate Tedesco on 10/29/22.
//

import Foundation
import SwiftUI

extension NotificationManager {
    
    func Set(flow: Bool, time: Int, elapsed: Int) {
        let content = UNMutableNotificationContent()
        
        content.title = flow ? "Flow Completed" : "Break Completed"
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "AquaSound.aif"))
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time - elapsed), repeats: false)
        let req = UNNotificationRequest(identifier: "timerCompleted", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil) // Show in background

        UNUserNotificationCenter.current().delegate = self // Play in foreground
    }
    
    
    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
