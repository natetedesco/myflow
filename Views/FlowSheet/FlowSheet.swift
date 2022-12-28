//
//  SheetView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct FlowSheet: View {
    @AppStorage("ShowToolBar") var showToolBar = true
    @ObservedObject var model: FlowModel
    @Binding var flow: Flow
    
    @FocusState var focusedField: Field?
    @Binding var showFlow: Bool
    
    @State var chooseFlow = false
    @State var chooseBreak = false
    @State var chooseRound = false
    
    var minutes = [Int](0...60)
    var seconds = [Int](0...60)
    var rounds = [Int](0...10)
    var columns = [
        MultiComponentPicker.Column(label: "min", options: Array(0...60).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
        MultiComponentPicker.Column(label: "sec", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
    ]
    
    var body: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture { Save() }
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    FlowTitle
                    Menu {
                        Button(action: Delete) {
                            Text("Delete") }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.myBlue)
                            .font(.title3)
                            .padding(12)
                            .background(Circle().fill(.ultraThinMaterial.opacity(0.55)))
                    }
                }
                FlowModePicker
                
                if flow.simple {
                    // Flow Time
                    Button(action: toggleFlowPicker) {
                        VStack {
                            PickerLabel(text: "Flow: ",
                                        time: ((flow.flowMinuteSelection * 60) + flow.flowSecondsSelection),
                                        color: .myBlue)
                            if chooseFlow {
                                MultiComponentPicker(
                                    columns: columns,
                                    selections: [$flow.flowMinuteSelection, $flow.flowSecondsSelection])
                            }
                        }
                    }
                    Divider()
                    
                    // Break Time
                    Button(action: toggleBreakPicker) {
                        VStack {
                            PickerLabel(
                                text: "Break:",
                                time: ((flow.breakMinuteSelection * 60) + flow.breakSecondsSelection),
                                color: .gray)
                            if chooseBreak {
                                MultiComponentPicker(
                                    columns: columns,
                                    selections: [$flow.breakMinuteSelection, $flow.breakSecondsSelection])
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
                                        selection: $flow.roundsSelection,
                                        unit: rounds,
                                        label: "")
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
                if !flow.simple {
                    CustomFlow(flow: $flow)
                }
            }
            .modifier(CustomGlass())
        }
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
            showFlow = false;
            showToolBar = true
            if flow.new {
                model.addFlow(flow: flow)
            } else {
                model.editFlow(id: flow.id, flow: flow)
            }
        }
    }
    
    var FlowTitle: some View {
        TextField(flow.title, text: $flow.title)
            .font(.title)
            .foregroundColor(.gray)
            .focused($focusedField, equals: .flowname)
            .onAppear {
                if flow.new {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focusedField = .flowname }
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
            Text("\(flow.roundsSelection)")
        }
        .foregroundColor(.white.opacity(0.8))
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
        .frame(height: 200)
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
                        .frame(width: geometry.size.width / CGFloat(columns.count), height: geometry.size.height)
                        .clipped()
                    }
                }
            }
        }
        .frame(height: 200).previewLayout(.sizeThatFits)
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
    case flowname
}

struct MaterialBackGround: View {
    var body: some View {
        Toolbar(model: FlowModel())
        Color.clear.opacity(0.0).ignoresSafeArea()
            .background(.ultraThinMaterial)
    }
}
