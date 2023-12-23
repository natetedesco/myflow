//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.

import Foundation


@Observable class FlowModel {
    var data = FlowData()
    var settings = Settings()
    var notifications = NotificationManager()
        
    var flow: Flow = Flow() { didSet { initialize() }}
    var flowList: [Flow] { didSet { initialize() }}
    
    var mode: TimerMode
    var timer = Timer()
    var start = Date()

    var flowTime = 0
    var flowTimeLeft = 0
    var breakTime = 0
    var breakTimeLeft = 0
    var elapsed = 0
    var totalFlowTime = 0
    var flowExtended = false
    
    var blocksCompleted = 0
    var selectedIndex = 0
    var showBlock = false
    
    var showFlowRunning = false
    var showFlowCompleted = false
    
    init(mode: TimerMode = .initial) {
        if let data = UserDefaults.standard.data(forKey: "SavedData") {
            if let decoded = try? JSONDecoder().decode([Flow].self, from: data) {
                flowList = decoded
                self.mode = mode
                initialize()
                return
            }
        }
        flowList = []
        self.mode = mode
        initialize()
    }
    
    // Initialize
    func initialize() {
        if let firstBlock = flow.blocks.first {
            // Set Flow Time based on the duration of the first block
            let time = (firstBlock.minutes * 60) + (firstBlock.seconds)
            flowTime = time
            flowTimeLeft = time
        }
    }
    
    // Create
    func createFlow(title: String) {
        flow = Flow(title: title)
        let updatedFlow = Flow(title: flow.title, blocks: flow.blocks)
        flowList.append(updatedFlow)
        save()
    }
    
    // Duplicate
    func duplicateFlow(flow: Flow) {
        let duplicatedFlow = Flow(id: UUID(), title: flow.title, blocks: flow.blocks)
        flowList.append(duplicatedFlow)
        save()
    }
    
    // Delete
    func deleteFlow(id: UUID) {
        if let index = flowList.firstIndex(where: { $0.id == id }) {
            flowList.remove(at: index)
            save()
        }
    }
    
    // Save Flow
    func saveFlow() {
        // Find the index of the current flow in flowList and update it
        if let index = flowList.firstIndex(where: { $0.id == flow.id }) {
            flowList[index] = Flow(id: flow.id, title: flow.title, blocks: flow.blocks)
            save()
        } else {
            print("Error: Flow not found.")
        }
    }
    
    // Save Data
    func save() {
        if let encoded = try? JSONEncoder().encode(flowList) {
            UserDefaults.standard.set(encoded, forKey: "SavedData")
        }
        initialize()
    }
    
    // BLOCKS //
    
    // Add
    func addBlock() {
        let newBlock = Block(title: "Focus", minutes: 20)
        flow.blocks.append(newBlock)
        selectedIndex = flow.blocks.firstIndex(where: { $0.id == newBlock.id }) ?? 0
        saveFlow()
    }
    
    // Duplicate
    func duplicateBlock(block: Block) {
        let newBlock = Block(title: block.title, minutes: block.minutes, seconds: block.seconds)
        flow.blocks.append(newBlock)
        saveFlow()
    }
    
    // Delete
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
    case breakRunning
    case breakPaused
}
