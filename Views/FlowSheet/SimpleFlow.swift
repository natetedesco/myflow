//
//  SimpleFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/27/22.
//

import SwiftUI

struct SimpleFlow: View {
    @Binding var flow: Flow
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
        VStack(alignment: .leading) {
            
            // Flow Time
            
            Button(action: toggleFlowPicker) { PickerLabel(flow: $flow, isFlow: true) }
            if chooseFlow {
                MultiComponentPicker(
                    columns: columns,
                    selections: [$flow.flowMinuteSelection, $flow.flowSecondsSelection])
            }
            Divider()
            
            // Break Time
            Button(action: toggleBreakPicker) { PickerLabel(flow: $flow, isFlow: false) }
            if chooseBreak {
                MultiComponentPicker(
                    columns: columns,
                    selections: [$flow.breakMinuteSelection, $flow.breakSecondsSelection])
            }
            Divider()
            
            // Rounds
            Button(action: toggleRoundsPicker) { RoundsLabel }
            if chooseRound {
                PickerView(
                    selection: $flow.roundsSelection,
                    unit: rounds,
                    label: "")
            }
        }
    }
    
    var RoundsLabel: some View {
        HStack {
            Text("Rounds")
                .foregroundColor(.white)
            Text("\(flow.roundsSelection)")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func toggleFlowPicker() {
        chooseFlow.toggle(); chooseBreak = false; chooseRound = false
    }
    
    func toggleBreakPicker() {
        chooseBreak.toggle(); chooseFlow = false; chooseRound = false
    }
    
    func toggleRoundsPicker() {
        chooseRound.toggle(); chooseFlow = false; chooseBreak = false
    }
}

struct PickerLabel: View {
    @Binding var flow: Flow
    var isFlow: Bool
    
    var body: some View {
        HStack {
            Text(isFlow ? "Flow" : "Break")
                .foregroundColor(.white)
                .font(.body)
            Text(formatTime(
                seconds: (isFlow ? flow.flowSecondsSelection : flow.breakSecondsSelection) +
                (isFlow ? flow.flowMinuteSelection * 60 : flow.breakMinuteSelection * 60)))
            .foregroundColor(isFlow ? .myBlue : .gray)
            .font(.callout)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PickerView: View {
    @Binding var selection: Int
    var unit: [Int]
    var label: String
    var body: some View {
        
        Picker(selection: $selection, label: Text("")) {
            ForEach(0..<unit.count, id: \.self) {
                Text("\(unit[$0]) \(label)")
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 200).previewLayout(.sizeThatFits)
    }
}

struct MultiComponentPicker<Tag: Hashable>: View  {
    let columns: [Column]
    var selections: [Binding<Tag>]
    
    init?(columns: [Column], selections: [Binding<Tag>]) {
        guard !columns.isEmpty && columns.count == selections.count else {
            return nil
        }
        self.columns = columns
        self.selections = selections
    }
    
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

