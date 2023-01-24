//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation
import SwiftUI

extension FlowModel {
    
    func setNotification(flow: Bool, time: Int) {
        notifications.Set(flow: flow, time: time, elapsed: elapsed)
    }
    
    func createDay() {
        data.createDayStruct()
    }
    
    func addTime(time: Int) {
        data.addTime(time: time)
        totalTime = totalTime + time
    }
    
    func timeLeft(end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        if isFlow() {
            setFlowTimeLeft(time: timeLeft)
        } else {
            setBreakTimeLeft(time: timeLeft)
        }
        return timeLeft
    }
    
    func setEnd(time: Int) -> Date {
        start = Date()
        let end = Calendar.current.date(byAdding: .second, value: (time - elapsed), to: start)!
        return end
    }
    
    // Set Flow Time
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    // Set Break Time
    func setBreakTime(time: Int) {
        breakTime = time
        breakTimeLeft = time
    }
    
    // Set Flow Time Left
    func setFlowTimeLeft(time: Int) {
        flowTimeLeft = time
    }
    
    // Set Break Time Left
    func setBreakTimeLeft(time: Int) {
        breakTimeLeft = time
    }
    
    // Set Both
    func setTimes(flowTime: Int, breakTime: Int) {
        setFlowTime(time: flowTime)
        setBreakTime(time: breakTime)
    }
    
    // Set Elapsed Time
    func setElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsed = elapsed + newTime
    }
    
    // Set Modes
    func setFlowStart() {
        mode = .flowStart
        type = .Flow
    }
    
    func setRunning(flow: Bool) {
        if flow {
            mode = .flowRunning
            type = .Flow
        } else {
            mode = .breakRunning
            type = .Break
        }
    }
    
    func setBreakStart() {
        mode = .breakStart
        type = .Break
    }
    func startFlow() {
        type = .Flow ;
        mode = .flowRunning
    }
    
    func startBreak() {
        mode = .breakRunning
        type = .Break
    }
    
}

class Settings: ObservableObject {
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
}
