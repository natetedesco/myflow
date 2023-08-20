//
//  SheetView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct FlowSheet: View {
    @ObservedObject var model: FlowModel
    @FocusState var focusedField: Field?
    @Binding var flow: Flow
    @Binding var show: Bool
    @Binding var disable: Bool
    @StateObject var settings = Settings()
    @State private var showingSheet = false
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    var body: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture {
                    Save()
                    disable = false
                }
                .disabled(flow.title.isEmpty)
                .opacity(show ? 1.0 : 0.0)
                .animation(.default.speed(show ? 2.0 : 1.0), value: show)
                .ignoresSafeArea(.keyboard)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    FlowTitle
                    flowSheetMenu
                }
                ZStack {
                    CustomFlow(flow: $flow)
                }
            }
            .customGlass()
            .opacity(show ? 1.0 : 0.0)
            .scaleEffect(show ? 1.0 : 0.96)
            .animation(.default.speed(show ? 1.0 : 2.0), value: show)
            .animation(.easeOut.speed(1.0), value: flow) // Custom Flow
            .padding(.vertical, 32)
            .fullScreenCover(isPresented: $showingSheet) {
                PayWall() }
        }
    }
    
    var flowSheetMenu: some View {
        Menu {
            Button(action: Delete) {
                Text("Delete") }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .myBlue()
                .CircularGlassButton()
        }
    }
    
    var FlowTitle: some View {
        ZStack {
            TextField("Title", text: $flow.title)
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.7))
                .focused($focusedField, equals: .flowName)
            if show {
                Text("")
                    .foregroundColor(.clear)
                    .onAppear {
                        if flow.new {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { focusedField = .flowName }
                        }
                    }
            }
        }
    }
    
    var SaveButton: some View {
        Button {
            Save()
        } label: {
            Text("Save")
                .myBlue()
                .centered()
        }
    }
    
    func Delete() {
        show = false;
        preventCrashFunc()
        model.deleteFlow(id: flow.id)
        if flow.new {
            model.selection = 0 // selects next flow
        }
    }
    
    func Save() {
        preventCrashFunc()
        show = false;
        if flow.new {
            model.addFlow(flow: flow)
            model.selection = (model.flowList.count - 1) // selects next flow
        } else {
            model.editFlow(id: flow.id, flow: flow)
        }
    }
    
    func preventCrashFunc() {
        flow.blocks.indices.forEach {
            flow.blocks[$0].pickTime = false
        }
    }
}

enum Field: Hashable {
    case flowName
    case blockName
    case time
}

struct Custom_Previews: PreviewProvider {
    @State static var model = FlowModel()
    static var previews: some View {
        ZStack {
            FlowView(model: model)
            FlowSheet(model: model, flow: $model.flow, show: .constant(true), disable: .constant(false))
                .opacity(1.0)
        }
    }
}

