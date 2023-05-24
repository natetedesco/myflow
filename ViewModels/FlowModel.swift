//
//  FlowModel.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation
import FamilyControls
import ManagedSettings

class FlowModel: ObservableObject {
    var data = FlowData()
    var settings = Settings()
    var notifications = NotificationManager()
    var deciveRestriction = MyMonitor()
    var timer = Timer()
    var start = Date()
    
    var flowTime = 0
    var breakTime = 0
    var roundsSet = 0
    var elapsed = 0
    var totalTime = 0
    var roundsCompleted = 0
    var blocksCompleted = 0
    var type: FlowType = .Flow
    var flowMode: FlowMode = .Simple
    
    @Published var flow: Flow = Flow()
    @Published var mode: TimerMode
    @Published var flowTimeLeft = 0
    @Published var breakTimeLeft = 0
    @Published var showFlow = false
    @Published var completed = false
    @Published var flowContinue = false
    @Published var flowList: [Flow] { didSet { Initialize() } }
    @Published var selection = 0 { didSet { Initialize() } }
    
    let store = ManagedSettingsStore()
    @Published var activitySelection = FamilyActivitySelection() { didSet { saveActivitySelection() } }
    
    init(mode: TimerMode = .Initial) {
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
        flowList = exampleFlows
        self.mode = mode
        Initialize()
    }
    
    
    // Save
    func saveActivitySelection() {
        if let encoded = try? JSONEncoder().encode(activitySelection) {
            UserDefaults.standard.set(encoded, forKey: "activitySelection")
        }
    }
    
    func startRestriction() {
        let applications = activitySelection.applicationTokens
        let categories = activitySelection.categoryTokens
        let webCategories = activitySelection.webDomainTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        store.shield.webDomains = webCategories
    }
    
    func stopRestrictions() {
        store.shield.applications = nil
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
