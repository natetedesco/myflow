//
//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation
import SwiftUI
import CoreData

class FlowModel: ObservableObject {
    var data = FlowData()
    var settings = Settings()
    var notifications = NotificationManager()
    var start = Date()
    var timer = Timer()
    
    var flowTime: Int = 0
    var breakTime: Int = 0
    var roundsSet: Int = 0
    var elapsedTime: Int = 0
    var totalFlowTime: Int = 0
    var roundsCompleted: Int = 0
    var flowContinue = false
    
    @Published var flow: Flow = Flow()
    @Published var mode: TimerMode = .Initial
    @Published var type: FlowType = .Flow
    @Published var flowMode: FlowMode = .Simple
    @Published var flowTimeLeft: Int = 0
    @Published var breakTimeLeft: Int = 0
    @Published var blocksCompleted: Int = 0
    @Published var completed = false
    @Published var showFlow = false
    
    @Published var flowList: [Flow] { didSet { Initialize() } }
    @Published var selection = 0 { didSet { Initialize() } }
    
    init() {
//        if let data = UserDefaults.standard.data(forKey: "SavedData") {
//            if let decoded = try? JSONDecoder().decode([Flow].self, from: data) {
//                flowList = decoded
//                Initialize()
//                return
//            }
//        }
        flowList = [
            Flow(title: "Flow", flowSeconds: 5, breakSeconds: 5, rounds: 5),
            Flow(title: "Workout", flowMinutes: 1, breakSeconds: 10)]
        Initialize()
    }
    
    // Add Flow
    func addFlow(flow: Flow) {
        flowList.append(updateFlow(flow: flow))
        save()
    }

    // Edit Flow
    func editFlow(id: UUID, flow: Flow) {
        if let updatedFlow = flowList.first(where: {$0.id == id}) {
            let index = flowList.firstIndex(of: updatedFlow)
            flowList[index!] = updateFlow(flow: flow)
        }
        save()
    }
    
    // Delete Flow
    func deleteFlow(id: UUID) {
        if let index = flowList.firstIndex(where: { $0.id == id }) {
            self.selection = 0 // select first in list
                flowList.remove(at: index)
                save()
        }
    }
    
    // Save
    func save() {
        if let encoded = try? JSONEncoder().encode(flowList) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
    }
    
    // update Flow
    func updateFlow(flow: Flow) -> Flow {
        let changedFlow =
        Flow(
        title: flow.title,
        simple: flow.simple,
        blocks: flow.blocks,
        flowMinutes: flow.flowMinutes,
        flowSeconds: flow.flowSeconds,
        breakMinutes: flow.breakMinutes,
        breakSeconds: flow.breakSeconds,
        rounds: flow.rounds
        )
        return changedFlow
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
