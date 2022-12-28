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
    @State var showFlowCompleted = true
    
    var body: some View {
        ZStack {
            
            Button(action: editFlow) {
                Circles(model: model) }
            
            ControlBar
            
            TimerLabels(model: model)
            
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
    }
    
    var FlowCompleted: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture {
                    model.Reset()
                }
            VStack(alignment: .center, spacing: 16) {
                Text("Flow Completed")
                    .font(.title)
                
                Text("Total Flow Time: ")
                Text(formatHoursAndMinutes(time: model.totalFlowTime))
                    .foregroundColor(.myBlue)
            }
            .modifier(CustomGlass())
            .frame(maxWidth: .infinity)
        }
    }
    
    var ControlBar: some View {
        
        // Continue Button
        ZStack {
            if model.mode == .breakStart || model.flowContinue {
                ContinueButton(model: model)
            }
            
            // Flow Menu
            else if model.mode == .Initial || model.mode == .flowRunning || model.mode == .breakRunning && !model.flowContinue {
                Menu {
                    Button(action: createFlow) {
                        Label("Create", systemImage: "plus") }
                    
                    Button(action: editFlow) {
                        Label("Edit", systemImage: "pencil") }
                    
                    Picker(selection: $model.selection) {
                        ForEach(0..<$model.flowList.count, id: \.self) { index in
                            Text(model.flowList[index].title)
                        }
                    } label:{}
                }
            label: { MenuLabel }
            }
            
            // Control Bar
            else {
                HStack(spacing: 60) {
                    Button(action: model.Restart) {
                        ChevronButton(image: "chevron.left") }
                    
                    Button(action: model.Reset) {
                        ResetButton }
                    
                    Button(action: model.Skip) {
                        ChevronButton(image: "chevron.right") }
                }
            }
        }
        .modifier(ButtonGlass())
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
        .animation(.easeInOut(duration: 0.15), value: model.mode)
        .animation(.easeInOut(duration: 0.15), value: model.flowList)
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
    
    var MenuLabel: some View {
        Text(model.flowList[model.selection].title)
            .font(.title2)
            .fontWeight(.light)
            .accentColor(.myBlue)
    }
    
    var ResetButton: some View {
        Image(systemName: "gobackward")
            .foregroundColor(.myBlue)
            .font(Font.system(size: 20))
    }
}

struct ChevronButton: View {
    var image: String
    
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.myBlue)
            .font(Font.system(size: 20))
    }
}

struct ContinueButton: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        if model.mode == .breakStart {
            Button {
                model.continueFlow()
            } label: {
                Text("Continue Flow")
                    .font(.title2)
                    .fontWeight(.light)
                    .accentColor(.myBlue)
            }
        }
        
        else {
            Button {
                model.completeContinueFlow()
            } label: {
                Text("Complete Flow")
                    .font(.title2)
                    .fontWeight(.light)
                    .accentColor(.myBlue)
            }
        }
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(model: FlowModel())
    }
}

