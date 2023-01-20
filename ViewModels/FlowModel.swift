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
    @Published var mode: TimerMode
    @Published var type: FlowType = .Flow
    @Published var flowMode: FlowMode = .Simple
    @Published var flowTimeLeft: Int = 0
    @Published var breakTimeLeft: Int = 0
    @Published var blocksCompleted: Int = 0
    @Published var completed = false
    @Published var showFlow = false
    
    @Published var flowList: [Flow] { didSet { Initialize() } }
    @Published var selection = 0 { didSet { Initialize() } }
    
    init(mode: TimerMode = .Initial) {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Flow].self, from: data) {
                flowList = decoded
                self.mode = mode
                Initialize()
                return
            }
        }
        flowList = exampleFlows
        self.mode = mode
        Initialize()
    }
    
    func createFlow() {
        flow = Flow(new: true)
        showFlow = true
    }
    
    func editFlow() {
        showFlow = true
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
            flowMinutes: flow.flowMinutes,
            flowSeconds: flow.flowSeconds,
            breakMinutes: flow.breakMinutes,
            breakSeconds: flow.breakSeconds,
            rounds: flow.rounds,
            blocks: flow.blocks
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

var exampleFlows = [
    
    Flow(
        title: "Flow"),
    
    Flow(
        title: "Workout", simple: false, blocks: [
            Block(flow: true, title: "Warm Up", minutes: 15),
            Block(flow: true, title: "Workout", minutes: 40),
            Block(flow: true, title: "Cool Down", minutes: 5)
        ]),
    
    Flow(
        title: "Creativity", simple: false, blocks: [
            Block(flow: true, title: "Brainstorm", minutes: 15),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Create", minutes: 30),
            Block(flow: false, title: "Break", minutes: 5),
            Block(flow: true, title: "Revision", minutes: 15)])
]

var exampleDays = [
    Day(day: Date.from(year: 2023, month: 1, day: 9), time: 135),
    Day(day: Date.from(year: 2023, month: 1, day: 7), time: 80),
    Day(day: Date.from(year: 2023, month: 1, day: 6), time: 115),
    Day(day: Date.from(year: 2023, month: 1, day: 5), time: 95),
    Day(day: Date.from(year: 2023, month: 1, day: 4), time: 39),
    Day(day: Date.from(year: 2023, month: 1, day: 3), time: 75),
    Day(day: Date.from(year: 2023, month: 1, day: 2), time: 90),
    Day(day: Date.from(year: 2023, month: 1, day: 1), time: 50)
]
