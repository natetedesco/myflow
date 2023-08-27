//
// Notifications.swift
//  Flow Timer
//  Created by Nate Tedesco on 6/21/21.
//

import Foundation
import UserNotifications

final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate  {
    var settings = Settings()
    @Published private(set) var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    // Set Notification
    func Set(flow: Bool, time: Int, elapsed: Int, id: String = "timer") {
        if settings.notificationsOn {
            
        let content = UNMutableNotificationContent()
        content.title = flow ? "Flow Completed" : "Break Completed"
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "AquaSound.aif"))
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time - elapsed), repeats: false)
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil) // Show in background
        UNUserNotificationCenter.current().delegate = self // Play in foreground
        }
    }
    
    // Remove Notifications
    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Reload Authorization
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    // Request Authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized: .denied
            }
        }
    }
    
    // Reload Local Notifications
    func reloadLocalNotifications() {
        print("reloadLocalNotifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound])
    }
}
