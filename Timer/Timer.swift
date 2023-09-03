//
//  SimpleHelpers.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation
import UserNotifications

extension FlowModel {
    
    // Initialize
    func Initialize() {
        if flowList.count != 0 {
            self.flow = flowList[selection]
        } else {
            self.flow = Flow(new: true, title: "Flow")
        }
        type = .Flow
        setFlowTime(time: (flow.blocks[0].hours * 3600) + (flow.blocks[0].minutes * 60) + (flow.blocks[0].seconds))
    }
    
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
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in}
    }
    
    // Run
    func Run(time: Int, flow: Bool) {
        setRunning(flow: flow)
        let end = setEnd(time: time)

        setNotification(flow: flow, time: time)
        startActivity(flow: flow, start: start, end: end)
        if settings.blockDistractions && flow == true { startRestriction() }
        
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
//        print(mode)
    }
    
    // End
    func endTimer(skip: Bool = false) {
        invalidateTimer()
        stopActivity()
        stopRestrictions()
        elapsed = 0
        completeBlock()
    }
    
    // Complete Block
    func completeBlock() {
        blocksCompleted += 1
        if blocksCompleted == flowList[selection].blocks.count {
            completeSession()
        }
        else {
            setNextBlock()
        }
    }
    
    // Set Next Block
    func setNextBlock() {
        
        let block = flowList[selection].blocks[blocksCompleted]
        let time = (block.hours * 3600) + (block.minutes * 60) + (block.seconds)
        
        if block.flow {
            setFlowTime(time: (block.minutes * 60) + block.seconds)
            setFlowStart()
        } else {
            setBreakTime(time: (block.minutes * 60) + block.seconds)
            setBreakStart()
        }
    }
}
