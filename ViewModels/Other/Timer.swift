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
        // Reset from last run
        if mode == .initial {
            totalFlowTime = 0
        }
        
        if flowTime > 0 && !flow.blocks.isEmpty{
            stopActivity()
            switch mode {
            case .initial: Run()
            case .flowStart: Run()
            case .flowRunning: Pause()
            case .flowPaused: flowExtended ? extend() : Run()
            case .breakRunning: pauseBreak()
            case .breakPaused: startBreak()
            }
            data.createDayStruct()
        }
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in}
    }
    func startBreak() {
        mode = .breakRunning
        breakTimeLeft = breakTime - elapsed // for Label

        if settings.focusOnStart { showFlowRunning = true }

        // Set End
        start = Date()
        let end = Calendar.current.date(byAdding: .second, value: (breakTime - elapsed), to: start)!
        
        notifications.Set(time: breakTime, elapsed: elapsed, id: "timer", isBreak: true)
        startActivity(start: start, end: end, isBreak: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
            breakTimeLeft = timeLeft
            if timeLeft <= 0 {
                breakTimeLeft = 0
                
                endBreak()
            }
        }
    }
    
    func pauseBreak() {
        mode = .breakPaused
        
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsed = elapsed + newTime
        
        invalidateTimer()
    }
    
    func endBreak() {
        showFlowRunning = false
        mode = .flowStart
        elapsed = 0
        invalidateTimer()
        stopActivity()
    }
    
    // Run
    func Run() {
        mode = .flowRunning
        
        if settings.focusOnStart { showFlowRunning = true }
        
        // Set End
        start = Date()
        let end = Calendar.current.date(byAdding: .second, value: (flowTime - elapsed), to: start)!
        
        notifications.Set(time: flowTime, elapsed: elapsed, id: "timer")
        startActivity(start: start, end: end)
        settings.startRestriction()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            if timeLeft(end: end) <= 0 {
                flowTimeLeft = 0
                
                // Add Time
                data.addTime(time: flowTime)
                addTotalFlowTime(time: flowTime)
                
                endTimer()
            }
        }
    }
    
    // End
    func endTimer(skip: Bool = false) {
        elapsed = 0
        settings.stopRestrictions()
        invalidateTimer()
        stopActivity()
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
            
            // Set Flow Time
            let time = (block.minutes * 60) + (block.seconds)
            flowTime = time
            flowTimeLeft = time
            mode = .flowStart
        }
            showFlowRunning = false
    }
    
    // Pause
    func Pause() {
        mode = .flowPaused
        
        // Set elapsed time
        let newTime = Int(abs(start.timeIntervalSinceNow))
        elapsed = elapsed + newTime
        
        invalidateTimer()
        settings.stopRestrictions()
    }
    
    // Skip
    func Complete() {
        if flowExtended {
            data.addTime(time: flowTimeLeft)
            addTotalFlowTime(time: flowTimeLeft)
            flowExtended = false
            flowTimeLeft = flowTime
        } else {
            let time = flowTime - flowTimeLeft
            data.addTime(time: time)
            addTotalFlowTime(time: time)
        }
        
        elapsed = 0
        endTimer()
    }
    
    
    // Reset
    func Reset() {
        rigidHaptic()
        if !flowExtended {
            let time = flowTime - flowTimeLeft
            data.addTime(time: time)
            addTotalFlowTime(time: time)
        }
        invalidateTimer()
        stopActivity()
        completeSession()
        settings.stopRestrictions()
        flowExtended = false
    }
    
    // Continue Flow
    func extend() {
        var start = Date()
        if settings.focusOnStart { showFlowRunning = true }
        
        if mode == .flowStart { // dont want to do this after unpause
            blocksCompleted = blocksCompleted - 1
        }
        
        if flowExtended {
            start = Calendar.current.date(byAdding: .second, value: (-flowTimeLeft), to: start)!
        }
        if !flowExtended {
            flowTimeLeft = 0 // so label doesnt display original flowtime
        }
        
        startActivity(start: start, end: start, extend: true)
        
        mode = .flowRunning
        flowExtended = true
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            flowTimeLeft = (Calendar.current.dateComponents([.second], from: start, to: Date()).second ?? 0)
        }
    }
    
    func completeSession() {
        showFlowRunning = false
        mode = .initial
        elapsed = 0
        blocksCompleted = 0
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showFlowCompleted  = true
        }
        initialize()
    }
    
    // Helpers
    
    // Time Left
    func timeLeft(end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        flowTimeLeft = timeLeft
        return timeLeft
    }
    
    // Invalidate Timer
    func invalidateTimer() {
        timer.invalidate()
        notifications.removeAllPendingNotificationRequests()
    }
    
    func addTotalFlowTime(time: Int) {
        totalFlowTime = totalFlowTime + time
    }
    // Restart
    func resetBlock() {
        flowExtended = false
        elapsed = 0
        if mode == .flowRunning || mode == .flowPaused {
            flowTimeLeft = flowTime
            invalidateTimer()
        } else {
            if blocksCompleted != 0 {
                blocksCompleted -= 1
                let block = flow.blocks[blocksCompleted]
                let time = (block.minutes * 60) + (block.seconds)
                flowTime = time
                flowTimeLeft = time
            }
        }
        mode = .flowStart
    }
}

