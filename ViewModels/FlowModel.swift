//
//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation
import FamilyControls
import ManagedSettings


@Observable class FlowModel {
    var data = FlowData()
    var settings = Settings()
    var notifications = NotificationManager()
    
    var flow: Flow = Flow() 
    var flowList: [Flow] { didSet { Initialize() } }
    var selection = 0 { didSet { Initialize() } }
    
    var mode: TimerMode
    
    var timer = Timer()
    
    var start = Date()
    var end = Date()

    
    var flowTime = 0
    var flowTimeLeft = 0
    var elapsed = 0
    var totalFlowTime = 0
    var flowContinue = false
    
    // Blocks
    var blocksCompleted = 0
    var blockSelected = false
    var showBlock = false
    var selectedIndex = 0

    var draggingItem: Block?
    var dragging = false
    
    var showFlowRunning = false
    var showFlowCompleted = false
    var showFlow = false
    
    let store = ManagedSettingsStore()
    var activitySelection = FamilyActivitySelection() { didSet { saveActivitySelection()}}
    
    init(mode: TimerMode = .initial) {
        if let data = UserDefaults.standard.data(forKey: "activitySelection") {
            if let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
                activitySelection = decoded
            }
        }
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
//            createFlow(title: "Flow")
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
//        flowList.insert(updatedFlow, at: 0)
        flowList.append(updatedFlow)
        selection = 0
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
        if let updatedFlow = flowList.first(where: {$0.id == flow.id}) {
            let index = flowList.firstIndex(of: updatedFlow)
            flowList[index!] = Flow(title: flow.title, blocks: flow.blocks)
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
        Initialize()
    }
    
    func addBlock() {
        let newBlock = Block(title: "", minutes: 20)
        flow.blocks.append(newBlock)
        blockSelected = true
        selectedIndex = flow.blocks.firstIndex(where: { $0.id == newBlock.id }) ?? 0
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
var initial = TimerMode.initial
var flowStart = TimerMode.flowStart
var flowRunning = TimerMode.flowRunning
var flowPaused = TimerMode.flowPaused
var completed = TimerMode.completed


