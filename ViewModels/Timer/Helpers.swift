//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation
import SwiftUI

extension FlowModel {
    
    // Create Day
    func createDay() {
        data.createDayStruct()
    }
    
    // Add Time
    func addTime(time: Int) {
        data.addTime(time: time)
        totalTime = totalTime + time
    }
    
    // Time Left
    func timeLeft(end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        
        if isFlow() {
            setFlowTimeLeft(time: timeLeft)
        } else {
            setBreakTimeLeft(time: timeLeft)
        }
        return timeLeft
    }
    
    // Set End
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
    
    // Set Running
    func setRunning(flow: Bool) {
        if flow {
            mode = .flowRunning
            type = .Flow
        } else {
            mode = .breakRunning
            type = .Break
        }
    }
    
    // Set Break Start
    func setBreakStart() {
        mode = .breakStart
        type = .Break
    }
    
    // Start FLow
    func startFlow() {
        type = .Flow ;
        mode = .flowRunning
    }
    
    // Start Break
    func startBreak() {
        mode = .breakRunning
        type = .Break
    }
}

class Settings: ObservableObject {
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
}
