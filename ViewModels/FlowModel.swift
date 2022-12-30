//
//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation
import SwiftUI

class FlowModel: ObservableObject {
    var notifications = NotificationManager()
    var data = FlowData()
    var timer = Timer()
    var start = Date()
    var elapsedTime = 0
    
    @Published var flow: Flow
    
    @Published var mode: TimerMode = .Initial
    @Published var type: FlowType = .Flow
    @Published var flowMode: FlowMode = .Simple
    
    @Published var flowTime: Int = 0
    @Published var breakTime: Int = 0
    @Published var roundsSet: Int = 0
    
    @Published var flowTimeLeft: Int = 0
    @Published var breakTimeLeft: Int = 0
    
    @Published var roundsCompleted: Int = 0
    @Published var blocksCompleted: Int = 0
    @Published var totalFlowTime: Int = 0
    @Published var completed = false
    @Published var flowContinue = false
    
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
    
    @Published var flowList: [Flow] {
        didSet { // update values if a flow is modified
            Initialize()
        }
    }
    
    @Published var selection = 0 {
        didSet { // update values if selection changes
            Initialize()
        }
    }
    
    init() {
        // if data
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Flow].self, from: data) {
                flowList = decoded
                flow = Flow()
                Initialize()
                return
            }
        }
        // if no data
        flowList = [
            Flow(title: "Flow", flowMinutes: 20, breakMinutes: 5, rounds: 5),
            Flow(title: "Study", flowMinutes: 10, breakMinutes: 10),
            Flow(title: "Exercise")]
        flow = Flow()
    }
    
    func Initialize() {
        let selection = flowList[selection]
        elapsedTime = 0
        roundsCompleted = 0
        blocksCompleted = 0
        
        mode = .Initial
        selection.simple ? setSimple() : setCustom()
        
        // Initialize Simple
        if flowMode == .Simple {
            setFlowTime(time: (selection.flowMinutes * 60) + selection.flowSeconds )
            setBreakTime(time: (selection.breakMinutes * 60) + selection.breakSeconds)
            roundsSet = selection.rounds // Add if rounds asp
        }
        
        // Initialize Custom
        if flowMode == .Custom {
            mode = .Initial
            if selection.blocks.indices.contains(0) {
                if selection.blocks[0].flow {
                    setFlowTime(time: (selection.blocks[0].minutes * 60) + selection.blocks[0].seconds)
                    type = .Flow
                }
                
                if !selection.blocks[0].flow {
                    setBreakTime(time: (selection.blocks[0].minutes * 60) + selection.blocks[0].seconds)
                    mode = .breakStart
                    type = .Break
                }
            }
            else {
                setFlowTime(time: 0)
                type = .Flow
            }
        }
    }
}

enum FlowType {
    case Flow
    case Break
}

enum FlowMode {
    case Simple
    case Custom
}

enum TimerMode {
    case Initial
    case flowStart
    case flowRunning
    case flowPaused
    case breakStart
    case breakRunning
    case breakPaused
}
