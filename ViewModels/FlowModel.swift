//
//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation
import SwiftUI

class FlowModel: ObservableObject {
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
    var notifications = NotificationManager()
    var data = FlowData()
    var start = Date()
    var timer = Timer()
    
    var flowTime: Int = 0
    var breakTime: Int = 0
    var roundsSet: Int = 0
    var elapsedTime = 0
    var totalFlowTime: Int = 0
    var roundsCompleted: Int = 0
    var flowContinue = false
    
    @Published var flow = Flow()
    @Published var mode: TimerMode = .Initial
    @Published var type: FlowType = .Flow
    @Published var flowMode: FlowMode = .Simple
    @Published var flowTimeLeft: Int = 0
    @Published var breakTimeLeft: Int = 0
    @Published var blocksCompleted: Int = 0
    @Published var completed = false
    
    @Published var flowList: [Flow] { didSet { Initialize() } }
    @Published var selection = 0 { didSet { Initialize() } }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Flow].self, from: data) {
                flowList = decoded
                Initialize()
                return
            }
        }
        flowList = [
            Flow(title: "Flow", flowMinutes: 20, breakMinutes: 5, rounds: 5),
            Flow(title: "Study", flowMinutes: 10, breakMinutes: 10),
            Flow(title: "Exercise")]
        Initialize()
    }
    
    func Initialize() {
        flow = flowList[selection]
        mode = .Initial
        flow.simple ? setSimple() : setCustom()
        elapsedTime = 0
        roundsCompleted = 0
        blocksCompleted = 0
        
        if flowMode == .Simple {
            setFlowTime(time: (flow.flowMinutes * 60) + flow.flowSeconds )
            setBreakTime(time: (flow.breakMinutes * 60) + flow.breakSeconds)
            roundsSet = flow.rounds // Add if rounds asp
        }
        if flowMode == .Custom {
            if flow.blocks.indices.contains(0) {
                if flow.blocks[0].flow {
                    setFlowTime(time: (flow.blocks[0].minutes * 60) + flow.blocks[0].seconds)
                    type = .Flow
                }
                else {
                    setBreakTime(time: (flow.blocks[0].minutes * 60) + flow.blocks[0].seconds)
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
