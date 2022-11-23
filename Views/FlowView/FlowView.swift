//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    @State var selectedFlow: Flow?
    
    var body: some View {
        ZStack {
            
            if model.completed {
                Text("Flow Completed")
                    .padding(.bottom, 500)
                    .foregroundColor(.myBlue)
                    .onTapGesture {
                        model.completed = false
                    }
            }
            
            FlowMenu(model: model, selectedFlow: $selectedFlow)
            
            if !model.simple {
                if model.mode == .Initial || model.mode == .flowStart || model.mode == .flowPaused || model.mode == .flowRunning {
                    FlowCircle(model: model)
                }
                if model.mode == .breakRunning || model.mode == .breakStart || model.mode == .breakPaused {
                    BreakCircle(model: model)
                }
            }
            
            
            if model.simple {
                if model.mode != .breakRunning {
                    FlowCircle(model: model)
                }
                if model.mode != .flowRunning {
                    BreakCircle(model: model)
                }
            }
            
            TimerLabels(model: model)
            
            Controls(model: model)
            
            if model.simple {
                Rounds(model: model)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: $selectedFlow) { flow in
            FlowSheet(flowModel: model, flow: flow)
                .background(.black)
                .presentationDetents([.large])
                .preferredColorScheme(.dark)
        }
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(model: FlowModel())
    }
}
