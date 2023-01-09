//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @ObservedObject var model: FlowModel
    @State var disable = false
    @AppStorage("showWelcome") var showWelcome: Bool = true
    @AppStorage("showCreateFlow") var showCreateFlow: Bool = true
    
    init(model: FlowModel) {
        self.model = model
        self.showCreateFlow = false
    }
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                FlowCenter
                
                Controls
                
                Toolbar(model: model)
            }
            .blur(radius: model.showFlow ? 10 : 0)
            .animation(.default, value: [model.showFlow, model.completed])
            
            if showWelcome {
                WelcomeScreen()
            }
            FlowCompleted
            FlowSheet(model: model, flow: $model.flow)
        }
        .FlowViewBackGround()
        .background(AnimatedBlur(opacity: moreBlur ? 1.0 : 0.0))
        .animation(.default.speed(1.5), value: moreBlur)
    }
    
    var FlowList: some View {
        Picker("", selection: $model.selection) {
            ForEach(0..<$model.flowList.count, id: \.self) { i in
                Text(model.flowList[i].title)
            }
        }
    }
    
    var moreBlur: Bool {
        if model.showFlow || model.completed || showWelcome {
            return true
        }
        return false
    }
    
    var FlowCenter: some View {
        Button {
            editFlow()
        } label: {
            ZStack {
                Circles(model: model)
                if showCreateFlow {
                    Text("Tap to create your first flow or select from the menu above")
                        .foregroundColor(.myBlue)
                        .padding(.horizontal, 70)
                } else {
                    TimerLabels(model: model)
                }
            }
        }
        .disabled(model.mode != .Initial)
        .disabled(disable)
    }
    
    @ViewBuilder var Controls: some View {
        // Menu must be reloaded or else doesnt update properly
        if model.showFlow == false {
            ControlBar
        }
        if model.showFlow == true {
            Text(model.flow.title)
                .buttonGlass()
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
        }
    }
    
    // Control Bar
    var ControlBar: some View {
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
                .disabled(model.mode != .Initial)
            } else {
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
        .animation(.easeInOut(duration: 0.25), value: model.selection)
    }
    
    var MenuLabel: some View {
        Title2(text: label)
            .fontWeight(.light)
    }
    
    var label: String {
        let label = model.flow.title
        return label
    }
    
    // Flow Completed
    var FlowCompleted: some View {
        ZStack {
            MaterialBackGround()
                .opacity(model.completed ? 1.0 : 0.0)
                .animation(.default.speed(model.completed ? 2.0 : 1.0), value: model.completed)
            VStack(alignment: .center, spacing: 16) {
                Title3(text: "Flow Completed")
                HStack {
                    Text("Time: ")
                        .font(.callout)
                    Text(formatHoursAndMinutes(time: model.totalFlowTime/60))
                        .foregroundColor(.myBlue)
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(.black.opacity(0.7))
            .cornerRadius(40)
            .padding(.horizontal, 48)
            .opacity(model.completed ? 1.0 : 0.0)
            .scaleEffect(model.completed ? 1.0 : 0.97)
            .animation(.default.speed(model.completed ? 1.0 : 2.0), value: model.completed)
            .animation(.default.speed(model.completed ? 1.0 : 2.0), value: model.flowContinue)

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
            Title3(text: model.mode == .breakStart ? "Continue Flow" : "Complete Flow")
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

