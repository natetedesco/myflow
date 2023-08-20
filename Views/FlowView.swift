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
    
    init(model: FlowModel) { self.model = model }
    
    var body: some View {
        ZStack {
            ZStack {
                
                FlowCenter
                
                ControlBar(model: model, mode: $model.mode, disable: $disable)
                
                Toolbar(model: model)
            }
            .FlowViewBackGround()
            .background(AnimatedBlur(opacity: moreBlur ? 1.0 : 0.0))
            .animation(.default.speed(1.5), value: moreBlur)
            .blur(radius: model.showFlow ? 10 : 0)
            .animation(.default, value: [model.showFlow, model.completed])
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                disable = false
                if showYourFlowHasBeenAdded == true {
                    showYourFlowHasBeenAdded = false
                }
            }
            
            FlowCompleted(model: model, show: $model.completed)
            FlowSheet(model: model, flow: $model.flow, show: $model.showFlow, disable: $disable)
        }
    }
    
    var FlowCenter: some View {
        Button {
            model.editFlow()
            mediumHaptic()
            disable = false
            
            if showCreateFlow == true {
                showYourFlowHasBeenAdded = true
            }
            showCreateFlow = false
        } label: {
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
        .disabled(model.mode != .Initial)
        .disabled(disable)
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
    
    var moreBlur: Bool {
        if model.showFlow || model.completed {
            return true
        }
        return false
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
