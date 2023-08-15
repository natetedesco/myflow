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
    @Binding var simple: Bool
    var showSeconds: Bool = false
    @Binding var disable: Bool
    @StateObject var settings = Settings()
    @State private var showingSheet = false

    @AppStorage("ProAccess") var proAccess: Bool = false

    var body: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture {
                    if !proAccess {
                        simple = true
                    }
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
                SegmentedPicker(simple: $simple)
                if simple {
                    FlowPicker
                    Divider()
                    BreakPicker
                    Divider()
                    RoundsPicker
                }
                if !simple {
                    ZStack {
                        CustomFlow(flow: $flow)
                            .disabled(!proAccess)
                            .blur(radius: proAccess ? 0 : 3)
                        if !proAccess {
                            VStack {
                                Button {
                                    showingSheet.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 20))
                                        Text("Unlock Pro")
//                                        .foregroundColor(.clear)
                                    }
                                    .smallButtonGlass()
                                        .foregroundColor(.myBlue)

                                }
                            }
                        }
                    }
                }
            }
            .customGlass()
            .opacity(show ? 1.0 : 0.0)
            .scaleEffect(show ? 1.0 : 0.96)
            .animation(.default.speed(show ? 1.0 : 2.0), value: show)
            .animation(.default.speed(1.0), value: chooseFlow)
            .animation(.default.speed(1.0), value: chooseBreak)
            .animation(.default.speed(1.0), value: chooseRound)
            .animation(.easeOut.speed(1.0), value: flow) // Custom Flow
            .padding(.vertical, 32)
            .fullScreenCover(isPresented: $showingSheet) {
                PayWall() }
        }
    }
    
    @State var chooseFlow = false
    var FlowPicker: some View {
        Button(action: toggleFlowPicker) {
            VStack {
                PickerLabel(text: "Flow: ", time: (flow.flowMinutes * 60) + flow.flowSeconds, color: .myBlue)
                if chooseFlow {
                    MultiComponentPicker(columns: columns, selections: [$flow.flowMinutes, $flow.flowSeconds])
                }
            }
            .animation(.default.speed(chooseFlow ? 0.7 : 2.0), value: chooseFlow)
        }
    }
    
    @State var chooseBreak = false
    var BreakPicker: some View {
        Button(action: toggleBreakPicker) {
            VStack {
                PickerLabel(text: "Break:", time: (flow.breakMinutes * 60) + flow.breakSeconds, color: .gray)
                if chooseBreak {
                    MultiComponentPicker(columns: columns,selections: [$flow.breakMinutes, $flow.breakSeconds])
                }
            }
            .animation(.default.speed(chooseBreak ? 0.7 : 2.0), value: chooseBreak)
        }
    }
    
    @State var chooseRound = false
    var RoundsPicker: some View {
        Button(action: toggleRoundsPicker) {
            VStack {
                HStack {
                    Text("Rounds:")
                        .font(.headline)
                    Text(roundsStrings[flow.rounds])
                        .font(flow.rounds == 0 ? .title3 : .body)
                        .fontWeight(flow.rounds == 0 ? .light : .regular)
                        .frame(maxHeight: 10)
                }
                .foregroundColor(.white.opacity(0.8))
                .leading()
                if chooseRound {
                    GeometryReader { geometry in
                        Picker(selection: $flow.rounds, label: Text("")) {
                            ForEach(rounds, id: \.self) { unit in
                                Text(roundsStrings[unit])
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(height: 166)
                    .padding(.vertical, -8)
                }
            }
        }
        .animation(.default.speed(chooseRound ? 0.7 : 2.0), value: chooseRound)
        .padding(.bottom, 4)
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
                .font(.title)
                .foregroundColor(.white.opacity(0.5))
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
    
    func toggleFlowPicker() {
        chooseFlow.toggle()
        chooseBreak = false
        chooseRound = false
    }
    func toggleBreakPicker() {
        chooseBreak.toggle()
        chooseFlow = false
        chooseRound = false
    }
    func toggleRoundsPicker() {
        chooseRound.toggle()
        chooseFlow = false
        chooseBreak = false
    }
    
    func preventCrashFunc() {
        chooseFlow = false
        chooseBreak = false
        chooseRound = false
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

struct Simple_Previews: PreviewProvider {
    @State static var model = FlowModel()
    static var previews: some View {
        ZStack {
            FlowView(model: model)
            FlowSheet(model: model, flow: $model.flow, show: .constant(true), simple: .constant(true), disable: .constant(false))
                .opacity(1.0)
        }
    }
}

struct Custom_Previews: PreviewProvider {
    @State static var model = FlowModel()
    static var previews: some View {
        ZStack {
            FlowView(model: model)
            FlowSheet(model: model, flow: $model.flow, show: .constant(true), simple: .constant(false), disable: .constant(false))
                .opacity(1.0)
        }
    }
}

