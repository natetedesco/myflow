//
//  SimpleHelpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation
import UserNotifications

extension FlowModel {
    
    // Start
    func Start() {
        if (flowTime > 0) {
            stopActivity()
            switch mode {
            case .initial: Run(time: flowTime)
            case .flowStart: Run(time: flowTime)
            case .flowRunning: Pause(flow: true)
            case .flowPaused: flowContinue ? continueFlow() : Run(time: flowTime)
            case .completed: Initialize()
            }
            data.createDayStruct()
        }
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in}
    }
    
    // Run
    func Run(time: Int) {
        mode = .flowRunning
        
        if settings.focusMode {
            showFlowRunning = true
        }
        
        let end = setEnd(time: time)
        
        setNotification(time: time)
        startActivity(start: start, end: end)
        settings.startRestriction()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if timeLeft(end: end) <= 0 {
                setFlowTimeLeft(time: 0)
                addTime(time: time)
                endTimer()
            }
        }
    }
    
    // End
    func endTimer(skip: Bool = false) {
        elapsed = 0
        invalidateTimer()
        stopActivity()
        settings.stopRestrictions()
        completeBlock()
    }
    
    // Complete Block
    func completeBlock() {
        blocksCompleted += 1
        if blocksCompleted == flow.blocks.count {
            completeSession()
        }
        else {
            let block = flow.blocks[blocksCompleted]
            setFlowTime(time: (block.hours * 3600) + (block.minutes * 60) + (block.seconds))
            mode = .flowStart
        }
    }
    
    // Pause
    func Pause(flow: Bool) {
        mode = .flowPaused
        setElapsedTime()
        invalidateTimer()
        
        settings.stopRestrictions()
    }
    
    // Skip
    func Skip() {
        elapsed = 0
        endTimer()
    }
    
    // Restart
    func Restart() {
        elapsed = 0
        mode = .flowStart
        if flowRunning() {
            setFlowTime(time: flowTime)
            invalidateTimer()
        } else {
            if blocksCompleted != 0 {
                blocksCompleted -= 1
                let block = flow.blocks[blocksCompleted]
                let time = (block.hours * 3600) + (block.minutes * 60) + (block.seconds)
                setFlowTime(time: time)
            }
        }
    }
    
    // Reset
    func Reset() {
        rigidHaptic()
        if !flowContinue {
            addTime(time: flowTime - flowTimeLeft)
        }
        invalidateTimer()
        stopActivity()
        completeSession()
        settings.stopRestrictions()
        flowContinue = false
    }
    
    // Continue Flow
    func continueFlow() {
        var start = Date()
        
        if flowContinue {
            start = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: start)!
        }
        mode = .flowRunning
        flowContinue = true
        startActivity(start: start, end: start, extend: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            flowTimeLeft = (Calendar.current.dateComponents([.second], from: start, to: Date()).second ?? 0)
        }
    }
    
    // Complete Continue Flow
    func completeContinueFlow() {
        invalidateTimer()
        addTime(time: flowTimeLeft)
        
        flowContinue = false
        flowTimeLeft = flowTime
        elapsed = 0
        
        blocksCompleted = blocksCompleted - 1
        completeBlock()
    }
    
    func completeSession() {
//        showFlow = false
        showFlowRunning = false
        mode = .initial
        elapsed = 0
        blocksCompleted = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showFlowCompleted  = true
            print("completed")
        }
        Initialize()
    }
}

// Helprs

extension FlowModel {
    
    
    // Add Time
    func addTime(time: Int) {
        data.addTime(time: time)
        totalFlowTime = totalFlowTime + time
    }
    
    // Time Left
    func timeLeft(end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        setFlowTimeLeft(time: timeLeft)
        
        return timeLeft
    }
    
    // Set Notification
    func setNotification(time: Int, id: String = "timer") {
        notifications.Set(time: time, elapsed: elapsed, id: id)
    }
    
    // Set End
    func setEnd(time: Int) -> Date {
        start = Date()
        let end = Calendar.current.date(byAdding: .second, value: (time - elapsed), to: start)!
        return end
    }
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    // Dismiss Completed
    func dismissCompleted() {
        totalFlowTime = 0
    }
    
    // Set Flow Time
    func setFlowTime(time: Int) {
        flowTime = time
        flowTimeLeft = time
    }
    
    // Set Flow Time Left
    func setFlowTimeLeft(time: Int) {
        flowTimeLeft = time
    }
    
    // Set Elapsed Time
    func setElapsedTime() {
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsed = elapsed + newTime
    }
    
    func flowRunning() -> Bool {
        if mode == .flowRunning || mode == .flowPaused {
            return true
        }
        return false
    }
 
    func flowPaused() -> Bool {
        if mode == .flowPaused {
            return true
        }
        return false
    }
    
    
    func flowStart() -> Bool {
        if mode == .flowStart {
            return true
        }
        return false
    }
}

