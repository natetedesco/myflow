//
//  ControlBar.swift
//  MyFlow
//  Created by Nate Tedesco on 1/19/23.
//

import SwiftUI

struct ControlBar: View {
    @AppStorage("showYourFlowHasBeenAdded") var showYourFlowHasBeenAdded: Bool = false
    @ObservedObject var model: FlowModel
    @Binding var mode: TimerMode
    @Binding var disable: Bool
    
    var body: some View {
        ZStack {
            if mode == .breakStart || mode == .flowStart || model.flowContinue {
                ContinueButton
                    .padding(.vertical, 2)
            } else if showFlowMenu {
                ZStack {
                    MenuLabel
                    Menu {
                        CreateFlowButton
                        EditFlowButton
                        DeleteFlowButton
                        FlowList
                    }
                label: { MenuLabel.foregroundColor(.clear) }
                        .onTapGesture {
                            disable = true
                            showYourFlowHasBeenAdded = false
                            if showYourFlowHasBeenAdded == true {
                                showYourFlowHasBeenAdded = false
                            }
                        }
                }
                .disabled(mode != .Initial)
            } else {
                // Control Bar
                HStack(spacing: 48) {
                    Button(action: model.Restart) { Chevron(image: "chevron.left") }
                    ResetButton
                    Button(action: model.Skip) { Chevron(image: "chevron.right") }
                }
                .padding(.vertical, 2)
            }
        }
        .myBlue()
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial.opacity(0.65))
        .cornerRadius(30)
        .top()
        .padding(.top)
        .animation(.easeInOut(duration: 0.15), value: mode)
        .animation(.easeInOut(duration: 0.25), value: model.selection)
        .frame(maxWidth: .infinity)
    }
    
    var FlowList: some View {
        Picker("", selection: $model.selection) {
            ForEach(0..<$model.flowList.count, id: \.self) { i in
                Text(model.flowList[i].title)
            }
        }
    }
    
    var MenuLabel: some View {
        HStack {
            Title2(text: label)
                .kerning(1.0)
        }
    }
    
    var label: String {
        let label = model.flow.title
        return label
    }
    
    var CreateFlowButton: some View {
        Button(action: model.createFlow) {
            Label("Create", systemImage: "plus")
        }
    }
    
    var EditFlowButton: some View {
        Button(action: model.editFlow) {
            Label("Edit", systemImage: "pencil")
        }
    }
    
    var DeleteFlowButton: some View {
        Button {
            model.deleteFlow(id: model.flow.id)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    var ResetButton: some View {
        Button(action: model.Reset) {
            Image(systemName: "gobackward")
                .font(Font.system(size: 20))
        }
    }
    
    @ViewBuilder var ContinueButton: some View {
        if mode == .flowStart || mode == .breakStart {
            HStack(spacing: 32) {
                Button(action: model.Restart) {
                    Chevron(image: "chevron.left")
                }
                Button {
                    model.continueFlow()
                } label: {
                    Title3(text: "Extend")
                        .fontWeight(.light)
                }
                Button(action: model.Skip) {
                    Chevron(image: "chevron.right")
                }
            }
        }
        else {
            HStack(spacing: 32) {
                Button {
                    mode == .breakStart ? model.continueFlow() : model.completeContinueFlow()
                } label: {
                    Title3(text: mode == .breakStart ? "Continue" : "Complete")
                        .fontWeight(.light)
                }
                if mode == .flowPaused {
                    ResetButton
                }
            }
        }
    }
    
    var showFlowMenu: Bool {
        if mode == .Initial || mode == .flowStart || mode == .flowRunning || mode == .breakRunning && !model.flowContinue {
            return true
        }
        return false
    }
}

