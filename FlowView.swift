//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @StateObject var model = FlowModel()
    @State var disable = false
    
    var body: some View {
        ZStack {
            FlowCenter
            
            ControlBar
            
            Toolbar(model: model)
            
            if model.completed {
                FlowCompleted
            }
            if model.showFlow {
                FlowSheet(model: model, flow: $model.flow)
            }
        }
        .FlowViewBackGround()
    }
    
    var FlowList: some View {
        Picker("", selection: $model.selection) {
            ForEach(0..<$model.flowList.count, id: \.self) { i in
                Text(model.flowList[i].title)
            }
        }
    }
    
    var FlowCenter: some View {
        Button(action: editFlow) {
            ZStack {
                Circles(model: model)
                TimerLabels(model: model)
            }
        }
        .disabled(model.mode != .Initial)
        .disabled(disable)
    }
    
    // Control Bar
    var ControlBar: some View {
        ZStack {
            if Continue {
                ContinueButton
            } else if showFlowMenu {
                Menu {
                    CreateFlowButton
                    EditFlowButton
                    FlowList
                }
            label: {
                MenuLabel
            }} else {
                // Control Bar
                HStack(spacing: 60) {
                    Button(action: model.Restart) { Chevron(image: "chevron.left") }
                    ResetButton
                    Button(action: model.Skip) { Chevron(image: "chevron.right") }
                }
            }
        }
        .buttonGlass()
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
        .animation(.easeInOut(duration: 0.15), value: model.mode)
        .animation(.easeInOut(duration: 0.15), value: model.flowList)
    }
    
    var MenuLabel: some View {
        Title2(text: model.flow.title)
            .fontWeight(.light)
    }
    
    // Flow Completed
    var FlowCompleted: some View {
        ZStack {
            MaterialBackGround()
            VStack(alignment: .center, spacing: 16) {
                Title(text: "Flow Completed")
                HStack {
                    Text("Total Flow Time: ")
                        .font(.callout)
                Text(formatHoursAndMinutes(time: model.totalFlowTime))
                    .foregroundColor(.myBlue)
                    .font(.headline)
                }
                
                Button {
                    model.dismissCompleted()
                } label: {
                    Text("Continue")
                        .foregroundColor(.myBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(.ultraThinMaterial.opacity(0.55))
                        .cornerRadius(30)
                        .padding(.top, 16)
                }
            }
            .customGlass()
            .frame(maxWidth: 380)
        }
        .onTapGesture {
            model.dismissCompleted()
        }
    }
    
    var CreateFlowButton: some View {
        Button(action: createFlow) {
            Label("Create", systemImage: "plus")
        }
    }
    
    var EditFlowButton: some View {
        Button(action: editFlow) {
            Label("Edit", systemImage: "pencil")
        }
    }
    
    var ResetButton: some View {
        Button(action: model.Reset) {
        Image(systemName: "gobackward")
            .font(Font.system(size: 20))
        }
    }
    
    var ContinueButton: some View {
        Button {
            model.mode == .breakStart ? model.continueFlow() : model.completeContinueFlow()
        } label: {
            Title2(text: model.mode == .breakStart ? "Continue Flow" : "Complete Flow")
                .fontWeight(.light)
        }
    }
    
    func createFlow() {
        model.flow = Flow(new: true)
        model.showFlow = true
    }
    
    func editFlow() {
        model.showFlow = true
    }
    
    var Continue: Bool {
        if model.mode == .breakStart || model.flowContinue {
            return true
        }
        return false
    }
    
    var showFlowMenu: Bool {
        if model.mode == .Initial || model.mode == .flowStart || model.mode == .flowRunning || model.mode == .breakRunning && !model.flowContinue {
            return true
        }
        return false
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(model: FlowModel())
    }
}

