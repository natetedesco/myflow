//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @AppStorage("ShowToolBar") var showToolBar = true
    @ObservedObject var model: FlowModel
    @State var showFlow = false
    @State var showControls = false
    
    var body: some View {
        ZStack {
            Button(action: editFlow) {
                ZStack {
                    Circles(model: model)
                    TimerLabels(model: model)
                }
            }
            .disabled(model.mode != .Initial)

            
            ControlBar
            
            if model.completed {
                FlowCompleted
            }
            
            if showFlow {
                FlowSheet(model: model, flow: $model.flow, showFlow: $showFlow)
            }
            if showToolBar && !model.completed {
                Toolbar(model: model)
            }
        }
        .background(AnimatedBlurOpaque())
        .animation(.easeInOut.speed(1.5), value: showFlow)
        .animation(.easeInOut.speed(1.5), value: model.completed)
    }
    
    // Control Bar
    var ControlBar: some View {
        ZStack {
            if showContinueButton {
                ContinueButton
            }
            
            else if showFlowMenu {
                Menu {
                    Button(action: createFlow) { Label("Create", systemImage: "plus") }
                        .disabled(model.mode != .Initial)

                    Button(action: editFlow) { Label("Edit", systemImage: "pencil") }
                        .disabled(model.mode != .Initial)

                    Picker(selection: $model.selection) {
                        ForEach(0..<$model.flowList.count, id: \.self) { index in
                            Text(model.flowList[index].title)
                        }
                    } label:{}
                        .disabled(model.mode != .Initial)
                }
            label: { MenuLabel }
            }
            
            else {
                HStack(spacing: 60) {
                    Button(action: model.Restart) { Chevron(image: "chevron.left") }
                    Button(action: model.Reset) { ResetButton }
                    Button(action: model.Skip) { Chevron(image: "chevron.right") }
                }
                .cornerRadius(30)
            }
        }
        .buttonGlass()
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
        .animation(.easeInOut(duration: 0.15), value: model.mode)
        .animation(.easeInOut(duration: 0.15), value: model.flowList)
    }
    
    // Flow Completed
    var FlowCompleted: some View {
        ZStack {
            MaterialBackGround()
            VStack(alignment: .center, spacing: 16) {
                Title(text: "Flow Completed")
                Text("Total Flow Time: ")
                Text(formatHoursAndMinutes(time: model.totalFlowTime))
                    .foregroundColor(.myBlue)
            }
            .customGlass()
            .frame(maxWidth: .infinity)
        }
        .onTapGesture {
            model.dismissCompleted()
        }
    }
    
    
    var MenuLabel: some View {
        Title2(text: model.flowList[model.selection].title)
            .fontWeight(.light)
            .accentColor(.myBlue)
    }
    
    var ResetButton: some View {
        Image(systemName: "gobackward")
            .foregroundColor(.myBlue)
            .font(Font.system(size: 20))
    }
    
    var ContinueButton: some View {
        Button {
            model.mode == .breakStart ? model.continueFlow() : model.completeContinueFlow()
        } label: {
            Title2(text: model.mode == .breakStart ? "Continue Flow" : "Complete Flow")
                .fontWeight(.light)
                .accentColor(.myBlue)
        }
    }
    
    func createFlow() {
        model.flow = Flow(new: true)
        showFlow = true
        showToolBar = false
    }
    
    func editFlow() {
        model.flow = model.flowList[model.selection]
        showFlow = true
        showToolBar = false
    }
    
    var showContinueButton: Bool {
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

