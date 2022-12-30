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
    
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
    
    var timer = Timer()
    var start = Date()
    var elapsedTime = 0
    
    @Published var flow: Flow
    
    @Published var mode: TimerMode = .Initial
    @Published var type: FlowType = .Flow
    @Published var flowMode: FlowMode = .Simple
    
    @Published var flowTime: Int = 0
    @Published var breakTime: Int = 0
    @Published var flowTimeLeft: Int = 0
    @Published var breakTimeLeft: Int = 0
    
    @Published var roundsSet: Int = 0
    @Published var roundsCompleted: Int = 0
    @Published var blocksCompleted: Int = 0
    
    @Published var totalFlowTime: Int = 0
    @Published var completed = false
    @Published var flowContinue = false
    
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
