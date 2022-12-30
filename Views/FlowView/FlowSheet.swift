//
//  SheetView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct FlowSheet: View {
    @AppStorage("ShowToolBar") var showToolBar = true
    @ObservedObject var model: FlowModel
    @FocusState var focusedField: Field?
    @Binding var flow: Flow
    @Binding var showFlow: Bool
    @State var chooseFlow = false
    @State var chooseBreak = false
    @State var chooseRound = false
    
    var body: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture {
                    Save()
                }
                .disabled(flow.title.isEmpty)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    FlowTitle
                    flowSheetMenu
                }
                
                FlowModePicker
                if flow.simple {
                    // Flow Time
                    Button(action: toggleFlowPicker) {
                        VStack {
                            PickerLabel(text: "Flow: ",
                                        time: ((flow.flowMinutes * 60) + flow.flowSeconds),
                                        color: .myBlue)
                            if chooseFlow {
                                MultiComponentPicker(
                                    columns: columns,
                                    selections: [$flow.flowMinutes, $flow.flowSeconds])
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Break Time
                    Button(action: toggleBreakPicker) {
                        VStack {
                            PickerLabel(
                                text: "Break:",
                                time: ((flow.breakMinutes * 60) + flow.breakSeconds),
                                color: .gray)
                            if chooseBreak {
                                MultiComponentPicker(
                                    columns: columns,
                                    selections: [$flow.breakMinutes, $flow.breakSeconds])
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Rounds
                    Button(action: toggleRoundsPicker) {
                        VStack {
                            RoundsLabel
                            if chooseRound {
                                HStack {
                                    PickerView(
                                        selection: $flow.rounds,
                                        unit: rounds,
                                        label: "")
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                if !flow.simple {
                    CustomFlow(flow: $flow)
                }
            }
            .customGlass()
            .frame(maxHeight: choose ? 600 : 290)
        }
    }
    
    var flowSheetMenu: some View {
        Menu {
            Button(action: Delete) {
                Text("Delete") }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .foregroundColor(.myBlue)
                .padding(12)
                .background(Circle().fill(.ultraThinMaterial.opacity(0.55)))
        }
    }
    
    var FlowTitle: some View {
        TextField("Title", text: $flow.title)
            .font(.largeTitle)
            .foregroundColor(.white.opacity(0.5))
            .focused($focusedField, equals: .flowName)
            .onAppear {
                if flow.new {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focusedField = .flowName }
                }
            }
    }
    
    var SaveButton: some View {
        Button {
            Save()
        } label: {
            Text("Save")
                .foregroundColor(.myBlue)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    var FlowModePicker: some View {
        Picker("", selection: $flow.simple, content: {
            Text("Simple").tag(true)
            Text("Custom").tag(false)
        })
        .pickerStyle(SegmentedPickerStyle())
        .padding(.vertical, 8)
    }
    
    var RoundsLabel: some View {
        HStack {
            Text("Rounds:")
                .font(.headline)
            Text("\(flow.rounds)")
        }
        .foregroundColor(.white.opacity(0.8))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var choose: Bool {
        if chooseFlow || chooseBreak || chooseRound {
            return true
        }
        return false
    }
    
    func Delete() {
        showFlow = false;
        showToolBar = true
        model.deleteFlow(id: flow.id)
        
    }
    
    func toggleFlowPicker() {
        chooseFlow.toggle()
    }
    func toggleBreakPicker() {
        chooseBreak.toggle()
    }
    func toggleRoundsPicker() {
        chooseRound.toggle()
    }
    
    func Save() {
        if !chooseFlow && !chooseBreak && !chooseRound {
            chooseFlow = false
            showFlow = false;
            showToolBar = true
            if flow.new {
                model.addFlow(flow: flow)
                model.selection = (model.flowList.count - 1)
            } else {
                model.editFlow(id: flow.id, flow: flow)
            }
        }
    }
}

struct PickerLabel: View {
    var text: String
    var time: Int
    var color: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.headline)
            Text(formatTime(seconds: time))
        }
        .foregroundColor(color)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PickerView: View {
    @Binding var selection: Int
    var unit: [Int]
    var label: String
    var body: some View {
        
        GeometryReader { geometry in
            Picker(selection: $selection, label: Text("")) {
                ForEach(0..<unit.count, id: \.self) {
                    Text("\(unit[$0]) \(label)")
                }
            }
            .pickerStyle(.wheel)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
                .frame(height: 150)
    }
}

struct MultiComponentPicker<Tag: Hashable>: View  {
    let columns: [Column]
    var selections: [Binding<Tag>]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(0 ..< columns.count, id: \.self) { index in
                    let column = columns[index]
                    ZStack(alignment: Alignment.init(horizontal: .customCenter, vertical: .center)) {
                        HStack {
                            Text(verbatim: column.options.last!.text)
                                .foregroundColor(.clear)
                                .alignmentGuide(.customCenter) { $0[HorizontalAlignment.center] }
                            Text(column.label)
                                .foregroundColor(.gray)
                        }
                        Picker(column.label, selection: selections[index]) {
                            ForEach(column.options, id: \.tag) { option in
                                Text(verbatim: option.text).tag(option.tag)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        //                        .accentColor(.white)
                        .frame(width: geometry.size.width / CGFloat(columns.count), height: geometry.size.height)
                        .clipped()
                    }
                }
            }
        }
        .frame(height: 150).previewLayout(.sizeThatFits)
    }
}

extension MultiComponentPicker {
    struct Column {
        struct Option {
            var text: String
            var tag: Tag
        }
        
        var label: String
        var options: [Option]
    }
}

private extension HorizontalAlignment {
    enum CustomCenter: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat { context[HorizontalAlignment.center] }
    }
    static let customCenter = Self(CustomCenter.self)
}

enum Field: Hashable {
    case flowName
}

struct MaterialBackGround: View {
    var body: some View {
        Toolbar(model: FlowModel())
        Color.clear.opacity(0.0).ignoresSafeArea()
            .background(.ultraThinMaterial)
    }
}
