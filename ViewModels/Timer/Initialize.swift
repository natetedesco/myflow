//
//  Initialize.swift
//  MyFlow
//  Created by Nate Tedesco on 1/24/23.
//

import Foundation

extension FlowModel {
    
    // Initialize
    func Initialize() {
        if flowList.count != 0 {
            self.flow = flowList[selection]
        } else {
            self.flow = Flow(new: true, title: "Flow")
        }
        flow.simple ? setSimple() : setCustom()
    }
    
    // Set Simple
    func setSimple() {
        flowMode = .Simple
        roundsSet = flow.rounds // Add if rounds asp
        setFlowTime(time: (flow.flowMinutes * 60) + flow.flowSeconds )
        setBreakTime(time: (flow.breakMinutes * 60) + flow.breakSeconds)
    }
    
    // Set Custom
    func setCustom() {
        flowMode = .Custom
        if flow.blocks.indices.contains(0) {
            if flow.blocks[0].flow {
                type = .Flow
                setFlowTime(time: (flow.blocks[0].minutes * 60) + flow.blocks[0].seconds)
            }
            else {
                setBreakTime(time: 0)
            }
        }
        else {
            type = .Flow
            setFlowTime(time: 0)
        }
    }
}
