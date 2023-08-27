//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @ObservedObject var model: FlowModel
    @State var disable = false
    @AppStorage("Onboarding") var onboarding: Bool = true
    @AppStorage("showCreateFlow") var showCreateFlow: Bool = true
    @FocusState var focusedField: Field?
    
    init(model: FlowModel) { self.model = model }
    
    var body: some View {
        ZStack {
            ZStack {
                
                // Control Bar
                ControlBar(model: model, mode: $model.mode, disable: $disable)
                
                // Extend
                VStack {
                    Spacer()
                    if (model.mode == .flowStart || model.mode == .breakStart || model.flowContinue) && model.blocksCompleted != 0 {
                        Button {
                            model.flowContinue ? model.completeContinueFlow() : model.continueFlow()
                        } label: {
                            HStack {
                                Text(model.flowContinue ? "Complete" : "Extend")
                            }
                            .foregroundColor(.myBlue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.ultraThinMaterial.opacity(0.8))
                            .cornerRadius(30)
                            .compositingGroup()
                            
                        }
                        .padding(.bottom, 128)
                    }
                }

                // Flow Center
                Button {
                    if disable {
                        disable = false
                    } else {
                        mediumHaptic()
                        model.showingSheet = true
                    }
                    showCreateFlow = false
                } label: {
                    FlowCenter
                }
                .disabled(model.mode != .Initial || disable)
                
                VStack {
                    
                    // Menu
                    Menu {
                        FlowList
                        EditFlowButton
                        DeleteFlowButton
                    }
                label: {
                    HStack {
                        Text(model.flow.title)
                            .font(.title)
                            .fontWeight(.medium)
                            .animation(.default, value: model.flow.title)
                        Image(systemName: "chevron.down")
                            .font(.footnote)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.4) // if title is too long
                    .frame(maxWidth: 200)
                    .foregroundColor(.white)
                    .padding(.leading)
                }
                .transaction { transaction in
                    transaction.animation = nil // disables ...
                }
                .onTapGesture {
                    print("disable on")
                    disable = true
                }
                .padding(.bottom, 128)
                }
                
                // ToolBar
                Toolbar(model: model)
            }
            .background(AnimatedBlur(opacity: 0.3))
            .background(.ultraThinMaterial.opacity(0.5))
            .ignoresSafeArea(.keyboard)
            .onTapGesture { disable = false }
            FlowCompleted(model: model, show: $model.completed)
        }
        .fullScreenCover(isPresented: $model.showingSheet) {
            FlowView2(model: model, flow: $model.flow)
        }
    }
    
    var FlowCenter: some View {
        ZStack {
            Circles(model: model)
            if showCreateFlow {
                createYourFlow
            } else {
                TimerLabels(model: model, mode: $model.mode)
            }
        }
    }
    
    var createYourFlow: some View {
        Text("Tap to create your flow")
            .foregroundColor(.white)
            .padding(.horizontal, 70)
            .frame(maxWidth: 400)
            .font(.title2)
            .fontWeight(.light)
    }
    
    var EditFlowButton: some View {
        Button {
            disable = false
            model.showingSheet = true
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
    
    var DeleteFlowButton: some View {
        Button(role: .destructive) {
            model.deleteFlow(id: model.flow.id)
        } label: {
            Label("Delete", systemImage: "trash")
        }
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
}

struct I: PreviewProvider {
    @State static var model = FlowModel()
    static var previews: some View {
        FlowView(model: model)
    }
}
struct P: PreviewProvider {
    @State static var model = FlowModel(mode: .flowPaused)
    static var previews: some View {
        FlowView(model: model)
    }
}

struct FS: PreviewProvider {
    @State static var model = FlowModel(mode: .flowStart)
    static var previews: some View {
        FlowView(model: model)
    }
}
struct FR: PreviewProvider {
    @State static var model = FlowModel(mode: .flowRunning)
    static var previews: some View {
        FlowView(model: model)
    }
}

struct BS: PreviewProvider {
    @State static var model = FlowModel(mode: .breakStart)
    static var previews: some View {
        FlowView(model: model)
    }
}
struct BR: PreviewProvider {
    @State static var model = FlowModel(mode: .breakRunning)
    static var previews: some View {
        FlowView(model: model)
    }
}
