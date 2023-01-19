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
        } label: {
            ZStack {
                Circles(model: model)
                if showCreateFlow {
                    Text("Tap to edit your flow or select from the menu above")
                        .myBlue()
                        .padding(.horizontal, 70)
                        .frame(maxWidth: 400)
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
    
struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(model: FlowModel())
    }
}
