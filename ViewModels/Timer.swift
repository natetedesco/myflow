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
        if timesSet() {
            stopActivity()
            switch mode {
            case .initial: Run(time: flowTime)
            case .flowStart: Run(time: flowTime)
            case .flowRunning: Pause(flow: true)
            case .flowPaused: flowContinue ? continueFlow() : Run(time: flowTime)
            case .completed: Initialize()
            }
            createDay()
        }
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in}
    }
    
    // Run
    func Run(time: Int) {
        mode = .flowRunning
        showFlowRunning = true
        
        end = setEnd(time: time)
        
        setNotification(time: time)
        if settings.liveActivities {
            startActivity(start: start, end: end)
        }
        if settings.blockDistractions == true { settings.startRestriction() }
        
//        flow.blocks[blocksCompleted].currentFocus = true
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showFlowRunning.toggle()
        }
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
}
