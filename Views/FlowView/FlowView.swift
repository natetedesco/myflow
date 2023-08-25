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
    @AppStorage("showYourFlowHasBeenAdded") var showYourFlowHasBeenAdded: Bool = false
    @AppStorage("showPause") var showPause: Bool = false
    
    @FocusState var focusedField: Field?
    
    init(model: FlowModel) { self.model = model }
    
    var body: some View {
        ZStack {
            ZStack {
                
                // Control Bar
                ControlBar(model: model, mode: $model.mode, disable: $disable)
                    .padding(.top)
                
                // Flow Center
                Button {
                    mediumHaptic()
                    disable = false
                    model.showingSheet = true
                    if showCreateFlow == true {
                        showYourFlowHasBeenAdded = true
                    }
                    showCreateFlow = false
                } label: {
                    FlowCenter
                }
                .disabled(model.mode != .Initial)
                .disabled(disable)
                
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
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .font(.footnote)
                    }
                    .padding(.leading)
                }
                .onTapGesture {
                    print("disable on")
                    disable = true
                    showYourFlowHasBeenAdded = false
                    if showYourFlowHasBeenAdded == true {
                        showYourFlowHasBeenAdded = false
                    }
                }
                .padding(.bottom, 128)
                }
                
                // Tool Bar
                Toolbar(model: model)
            }
            .background(AnimatedBlur(opacity: 0.3))
            .background(.ultraThinMaterial.opacity(0.5))
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                disable = false
                print("disable off")
                if showYourFlowHasBeenAdded == true {
                    showYourFlowHasBeenAdded = false
                }
            }
            FlowCompleted(model: model, show: $model.completed)
        }
        .fullScreenCover(isPresented: $model.showingSheet) {
            FlowView2(model: model, flow: $model.flow)
        }
    }
    
    var FlowCenter: some View {
        ZStack {
            Circles(model: model)
            if showPause {
                VStack {
                    Spacer()
                    Text("Pause to access skip, restart, and reset")
                        .foregroundColor(.white)
                        .font(.footnote)
                    Image(systemName: "arrow.down")
                        .padding(.bottom, 120)
                        .padding(.top, 1)
                        .foregroundColor(.white)
                        .font(.footnote)
                }
                .foregroundColor(.myBlue)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        onboarding = false
                        showPause = false
                    }
                }
            }
            if showYourFlowHasBeenAdded {
                yourFlowHasBeenAdded
            }
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
    
    var yourFlowHasBeenAdded: some View {
        VStack() {
            Image(systemName: "arrow.up")
                .padding(.top, 75)
                .padding(.bottom, 1)
                .foregroundColor(.white)
                .font(.footnote)
            Text("Your flow has been added to the list")
                .foregroundColor(.white)
                .font(.footnote)
            Spacer()
            
        }
        .foregroundColor(.myBlue)
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
