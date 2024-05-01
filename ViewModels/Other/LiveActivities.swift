//
//  LiveActivities.swift
//  MyFlow
//  Created by Nate Tedesco on 5/3/23.
//

import Foundation
import ActivityKit

extension FlowModel {
    
    func startActivity(start: Date, end: Date, paused: Bool = false, extend: Bool = false, isBreak: Bool = false) {
        if settings.liveActivities {
            let attributes = TimerWidgetAttributes(name: "flow")
            let initialContentState = TimerWidgetAttributes.TimerStatus(
                name: flow.title,
                blockName: isBreak ? "Break" : flow.blocks[blocksCompleted].title,
                value: start...end,
                paused: paused,
                time: isBreak ? breakTimeLeft : flowTimeLeft,
                start: Date(),
                extend: extend,
                blocks: flow.blocks.count,
                blocksCompleted: blocksCompleted,
                isBreak: isBreak
            )
            do {
                let activity = try Activity<TimerWidgetAttributes>.request(
                    attributes: attributes,
                    contentState: initialContentState,
                    pushType: nil)
            } catch (let error) {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func stopActivity() {
        Task {
            for activity in Activity<TimerWidgetAttributes>.activities{
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }
}
