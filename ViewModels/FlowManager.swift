//
//  FlowManager.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation

extension FlowModel {
    
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
    
    // Move Flow
    func moveFlow(from source : IndexSet, to destination : Int) {
        flowList.move(fromOffsets: source, toOffset: destination)
    }
    
    // Delete Flow
    func deleteFlow(id: UUID) {
        if let index = flowList.firstIndex(where: { $0.id == id }) {
            self.selection = 0 // select first in list when flow is deleted, avoid crash
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
        let changedFlow = Flow(
            
        title: flow.title,
        simple: flow.simple,
        blocks: flow.blocks,
        
        flowMinuteSelection: flow.flowMinuteSelection,
        flowSecondsSelection: flow.flowSecondsSelection,
        breakMinuteSelection: flow.breakMinuteSelection,
        breakSecondsSelection: flow.breakSecondsSelection,
        roundsSelection: flow.roundsSelection)
    
        return changedFlow
    }
}
