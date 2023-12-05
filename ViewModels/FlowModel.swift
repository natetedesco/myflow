//
//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation

@Observable class FlowModel {
    var data = FlowData()
    var settings = Settings()
    var notifications = NotificationManager()
    
    var flow: Flow = Flow() { didSet { Initialize() }}
    var flowList: [Flow] { didSet { Initialize() }}
    
    var mode: TimerMode
    
    var timer = Timer()
    var start = Date()

    var flowTime = 0
    var flowTimeLeft = 0
    var elapsed = 0
    var totalFlowTime = 0
    var flowContinue = false
    
    var blocksCompleted = 0
    var selectedIndex = 0
    var newBlock = false
    var showBlock = false
    
    var showFlowRunning = false
    var showFlowCompleted = false
    var showFlow = false
    
    init(mode: TimerMode = .initial) {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Flow].self, from: data) {
                flowList = decoded
                self.mode = mode
                Initialize()
                return
            }
        }
        flowList = []
        self.mode = mode
        Initialize()
    }
    
    // Initialize
    func Initialize() {
        if flowList.isEmpty {
        } else if let firstBlock = flow.blocks.first {
            setFlowTime(time: (firstBlock.hours * 3600) + (firstBlock.minutes * 60) + (firstBlock.seconds))
        } else {
            print("No blocks available in the flow.")
        }
    }
    
    // Create Flow
    func createFlow(title: String) {
        flow = Flow(title: title)
        let updatedFlow = Flow(title: flow.title, blocks: flow.blocks)
        flowList.append(updatedFlow)
        save()
    }
    
    func renameFlow(index: Int, newTitle: String) {
        flowList[index].title = newTitle
        save()
    }
    
    func duplicateFlow(flow: Flow) {
        let duplicatedFlow = flow
        flowList.append(duplicatedFlow)
        save()
    }
    
    // Save Flow
    func saveFlow() {
        if let index = flowList.firstIndex(where: { $0.id == flow.id }) {
            flowList[index] = Flow(id: flow.id, title: flow.title, blocks: flow.blocks)
            save()
        } else {
            print("Error: Flow not found.")
        }
    }

    
    // Delete Flow
    func deleteFlow(id: UUID) {
        if let index = flowList.firstIndex(where: { $0.id == id }) {
            flowList.remove(at: index)
            save()
        }
    }
    
    // Save
    func save() {
        if let encoded = try? JSONEncoder().encode(flowList) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
        Initialize()
    }
    
    func addBlock() {
        let newBlock = Block(title: "Focus", minutes: 20)
        flow.blocks.append(newBlock)
        selectedIndex = flow.blocks.firstIndex(where: { $0.id == newBlock.id }) ?? 0
        saveFlow()
    }
    
    func duplicateBlock(block: Block) {
        let newBlock = Block(title: block.title, seconds: Int(block.totalTimeInSeconds))
        flow.blocks.append(newBlock)
        saveFlow()
    }
    
    func deleteBlock(id: UUID) {
        if let index = flow.blocks.firstIndex(where: { $0.id == id }) {
            flow.blocks.remove(at: index)
            saveFlow()
        }
    }
}

enum TimerMode {
    case initial
    case flowStart
    case flowRunning
    case flowPaused
    case completed
}
