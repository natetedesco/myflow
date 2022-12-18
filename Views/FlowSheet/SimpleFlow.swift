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
            Button {
                chooseFlow.toggle(); chooseBreak = false; chooseRound = false
            } label: {
                PickerLabel(label: "Flow", minutes: flow.flowMinuteSelection, seconds: flow.flowSecondsSelection, color: .myBlue)
            }
            //Picker
            if chooseFlow {
                MultiComponentPicker(columns: columns, selections: [$flow.flowMinuteSelection, $flow.flowSecondsSelection]).frame(height: 200).previewLayout(.sizeThatFits)
            }
            Divider()
            
            // Break Time
            VStack {
                Button {
                    chooseBreak.toggle(); chooseFlow = false; chooseRound = false
                } label: {
                    PickerLabel(label: "Break", minutes: flow.breakMinuteSelection, seconds: flow.breakSecondsSelection, color: .gray)
                }
                // Picker
                if chooseBreak {
                    MultiComponentPicker(columns: columns, selections: [$flow.breakMinuteSelection, $flow.breakSecondsSelection]).frame(height: 200).previewLayout(.sizeThatFits)
                }
            }
        }
        Divider()
        
        // Rounds
        VStack {
            Button {
                chooseRound.toggle(); chooseFlow = false; chooseBreak = false
                
            } label: {
                RoundsLabel(rounds: flow.roundsSelection)
            }
            
            if chooseRound {
                PickerView(selection: $flow.roundsSelection, unit: rounds, label: "")
                    .frame(maxWidth: .infinity, maxHeight: 170, alignment: .center)
            }
        }
    }
}

struct PickerLabel: View {
    var label: String
    var minutes: Int
    var seconds: Int
    var color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.white)
                .font(.body)
            Text(formatTime(seconds: (seconds) + (minutes * 60)))
                .foregroundColor(color)
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


struct RoundsLabel: View {
    var rounds: Int
    
    var body: some View {
        HStack {
            let rounds = "\(rounds)"
            Text("Rounds")
                .foregroundColor(.white)
            Text(rounds)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
