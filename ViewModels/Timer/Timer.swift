//
//  SimpleHelpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation
import SwiftUI
import ActivityKit

extension FlowModel {
    
    // Start
    func Start() {
        if timesSet() {
            stopActivity()
            switch mode {
            case .Initial: Run(time: flowTime, flow: true)
            case .flowStart: Run(time: flowTime, flow: true)
            case .breakStart: Run(time: breakTime, flow: false)
            case .flowRunning: Pause(flow: true)
            case .breakRunning: Pause(flow: false)
            case .flowPaused: flowContinue ? continueFlow() : Run(time: flowTime, flow: true)
            case .breakPaused: Run(time: breakTime, flow: false)
            }
            createDay()
        }
    }
    
    // Run
    func Run(time: Int, flow: Bool) {
        setRunning(flow: flow)
        setSimpleNotification(flow: flow, time: time)
        let end = setEnd(time: time)
        
        startActivity(flow: flow, start: start, end: end)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if timeLeft(end: end) <= 0 {
                if isFlow() {
                    setFlowTimeLeft(time: 0)
                    addTime(time: time)
                } else {
                    setBreakTimeLeft(time: 0)
                }
                endTimer()
            }
        }
    }
    
    func startActivity(flow: Bool, start: Date, end: Date, paused: Bool = false) {
        let attributes = TimerWidgetAttributes(name: "flow")
        let initialContentState = TimerWidgetAttributes.TimerStatus(
            flow: flow,
            name: flow ? "Flow" : "Break",
            value: start...end,
            paused: paused,
            time: flowTimeLeft
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

