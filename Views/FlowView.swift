//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @ObservedObject var model: FlowModel
    @State var disable = false
    @AppStorage("showWelcome") var showWelcome: Bool = false
    @AppStorage("showCreateFlow") var showCreateFlow: Bool = true
    init(model: FlowModel) {
        self.model = model
    }
    
    var body: some View {
        ZStack {
            ZStack {
                FlowCenter
                Controls
                Toolbar(model: model)
            }
            .FlowViewBackGround()
            .background(AnimatedBlur(opacity: moreBlur ? 1.0 : 0.0))
            .animation(.default.speed(1.5), value: moreBlur)
            .blur(radius: model.showFlow ? 10 : 0)
            .animation(.default, value: [model.showFlow, model.completed])
            .ignoresSafeArea(.keyboard)
            
            if showWelcome {
                WelcomeScreen()
            }
            FlowCompleted(model: model, show: $model.completed)
            FlowSheet(model: model, flow: $model.flow, show: $model.showFlow, simple: $model.flow.simple)
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
            model.editFlow()
            showCreateFlow = false
        } label: {
            ZStack {
                Circles(model: model)
                if showCreateFlow {
                    Text("Tap to create your flow")
                        .myBlue()
                        .padding(.horizontal, 70)
                        .frame(maxWidth: 400)
                        .font(.title2)
                        .fontWeight(.light)
                } else {
                    TimerLabels(model: model, mode: $model.mode)
                }
            }
        }
        .disabled(model.mode != .Initial)
        .disabled(disable)
    }
    
    @ViewBuilder var Controls: some View {
        // Menu must be reloaded or else doesnt update properly
        if model.showFlow == false {
            ControlBar(model: model, mode: $model.mode)
        }
        if model.showFlow == true {
            Text(model.flow.title)
                .buttonGlass()
                .top()
                .padding(.top)
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
