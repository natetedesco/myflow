//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @ObservedObject var model: FlowModel
    @State var showFlow = false
    @State var preselectedIndex = 0
    
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
            
            Toolbar(model: model)
            
            if model.completed {
                FlowCompleted
            }
            if showFlow {
                FlowSheet(model: model, flow: $model.flow, showFlow: $showFlow)
            }
        }
        .background(.black.opacity(0.8))
        .background(.ultraThinMaterial)
        .background(AnimatedBlur(opacity: 0.3))
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
    
    var MenuLabel: some View {
        Title2(text: model.flowList[model.selection].title)
            .fontWeight(.light)
    }
    
    var ResetButton: some View {
        Image(systemName: "gobackward")
            .font(Font.system(size: 20))
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
        showFlow = true
    }
    
    func editFlow() {
        model.flow = model.flowList[model.selection]
        showFlow = true
        //        showToolBar = false
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

