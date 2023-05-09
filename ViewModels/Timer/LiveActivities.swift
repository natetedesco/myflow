//
//  LiveActivities.swift
//  MyFlow
//  Created by Nate Tedesco on 5/3/23.
//

import Foundation
import ActivityKit

extension FlowModel {
    
    func startActivity(flow: Bool, start: Date, end: Date, paused: Bool = false, extend: Bool = false) {
        let attributes = TimerWidgetAttributes(name: "flow")
        let initialContentState = TimerWidgetAttributes.TimerStatus(
            flow: flow,
            name: flow ? "Flow" : "Break",
            value: start...end,
            paused: paused,
            time: flowTimeLeft,
            start: Date(),
            extend: extend
        )
        
        do {
            let activity = try Activity<TimerWidgetAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil)
            print("error \(activity.id)")
        } catch (let error) {
            print("error \(error.localizedDescription)")
        }
    }
    
    func stopActivity() {
        Task {
            for activity in Activity<TimerWidgetAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    
//    func updateActivity(start: Date, end: Date, paused: Bool = false) {
//        Task {
//            let updatedStatus = TimerWidgetAttributes.TimerStatus(
//                value: start...end,
//                name: "flow",
//                paused: paused,
//                time: flowTimeLeft
//            )
//
//            for activity in Activity<TimerWidgetAttributes>.activities{
//                await activity.update(using: updatedStatus)
//            }
//        }
//    }
    
}