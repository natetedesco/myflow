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
            
            // Create Button
            if mode == .Initial {
                Button {
                    model.createFlow()
                    print("\(model.showingSheet)")
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
                .padding(.vertical, 12) // perfect circle
                .padding(.horizontal, 10)
                .disabled(mode != .Initial)
                
                // Control Bar
            } else {
                HStack(spacing: 48) {
                    Button(action: model.Restart) { Chevron(image: "chevron.left") }
                    
                    if showExtend {
                        ContinueButton
                            .padding(.vertical, 2)
                    } else {
                        ResetButton
                    }
                    
                    Button(action: model.Skip) { Chevron(image: "chevron.right") }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                
                
            }
        }
        .background(.ultraThinMaterial.opacity(0.65))
        .cornerRadius(mode == .Initial ? 50 : 30)
        .myBlue()
        .top()
        .animation(.easeInOut(duration: 0.15), value: mode)
        .animation(.easeInOut(duration: 0.25), value: model.selection)
        .frame(maxWidth: .infinity)
    }
    
    var FlowList: some View {
        Picker("", selection: $model.selection) {
            ForEach(0..<$model.flowList.count, id: \.self) { i in
                Text(model.flowList[i].title)
                    .onChange(of: model.selection) { newValue in
                        disable = false
                    }
            }
        }
    }
    
    var MenuLabel: some View {
        HStack {
            Title(text: label)
                .kerning(1.0)
        }
    }
    
    var label: String {
        let label = model.flow.title
        return label
    }
    
    var ResetButton: some View {
        Button(action: model.Reset) {
            Image(systemName: "gobackward")
                .font(Font.system(size: 24))
        }
    }
    
    @ViewBuilder var ContinueButton: some View {
        if mode == .flowStart || mode == .breakStart {
            Button {
                model.continueFlow()
            } label: {
                Title2(text: "Extend")
            }
        }
        else {
            Button {
                mode == .breakStart ? model.continueFlow() : model.completeContinueFlow()
            } label: {
                Title2(text: mode == .breakStart ? "Continue" : "Complete")
            }
        }
    }
    
    var showExtend: Bool {
        if mode == .breakStart || mode == .flowStart || model.flowContinue {
            return true
        }
        return false
    }
}

