//
//  ControlBar.swift
//  MyFlow
//  Created by Nate Tedesco on 1/19/23.
//

import SwiftUI

struct ControlBar: View {
    @ObservedObject var model: FlowModel
    @Binding var mode: TimerMode
    
    var body: some View {
        ZStack {
            if Continue {
                ContinueButton
            } else if showFlowMenu {
                ZStack {
                    MenuLabel
                    Menu {
                        CreateFlowButton
                        EditFlowButton
                        FlowList
                    }
                label: {
                    MenuLabel
                        .foregroundColor(.clear)
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
            }
        }
        .buttonGlass()
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
        Title2(text: label)
            .fontWeight(.light)
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
    
    var ResetButton: some View {
        Button(action: model.Reset) {
            Image(systemName: "gobackward")
                .font(Font.system(size: 20))
        }
    }
    
    @ViewBuilder var ContinueButton: some View {
        if mode == .breakStart {
            HStack(spacing: 20) {
                Button(action: model.Restart) { Chevron(image: "chevron.left") }
                Button {
                    model.continueFlow()
                } label: {
                    Title3(text: "Continue")
                        .fontWeight(.light)
                }
                Button(action: model.Skip) { Chevron(image: "chevron.right") }
            }
        }
        else {
            Button {
                mode == .breakStart ? model.continueFlow() : model.completeContinueFlow()
            } label: {
                Title3(text: mode == .breakStart ? "Continue" : "Complete")
                    .fontWeight(.light)
            }
        }
    }
    
    var Continue: Bool {
        if mode == .breakStart || model.flowContinue {
            return true
        }
        return false
    }
    
    var showFlowMenu: Bool {
        if mode == .Initial || mode == .flowStart || mode == .flowRunning || mode == .breakRunning && !model.flowContinue {
            return true
        }
        return false
    }
}

//struct Initial: PreviewProvider {
//    @State static var model = FlowModel()
//    static var previews: some View {
//        ControlBar(model: model, mode: .constant(.Initial))
//            .FlowViewBackGround()
//    }
//}
//
//struct Paused: PreviewProvider {
//    @State static var model = FlowModel()
//    static var previews: some View {
//            ControlBar(model: model, mode: .constant(.flowPaused))
//        .FlowViewBackGround()
//    }
//}
//
//struct Continue: PreviewProvider {
//    @State static var model = FlowModel()
//    static var previews: some View {
//            ControlBar(model: model, mode: .constant(.breakStart))
//        .FlowViewBackGround()
//    }
//}

