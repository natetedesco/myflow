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
    @State var pickTime = false
    @State var preventCrash = false
    @State var chooseFlow = false
    @State var chooseBreak = false
    @State var chooseRound = false
    
    var body: some View {
        
        ZStack {
            MaterialBackGround()
                .onTapGesture { Save() }
                .disabled(flow.title.isEmpty)
                .opacity(model.showFlow ? 1.0 : 0.0)
                .animation(.default.speed(model.showFlow ? 2.0 : 1.0), value: model.showFlow)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    FlowTitle
                    flowSheetMenu
                }
                SegmentedPicker
                if flow.simple {
                    FlowPicker
                    Divider()
                    BreakPicker
                    Divider()
                    RoundsPicker
                }
                if !flow.simple {
                    CustomFlow(flow: $flow, pickTime: $pickTime)
                }
            }
            .customGlass()
            .opacity(model.showFlow ? 1.0 : 0.0)
            .scaleEffect(model.showFlow ? 1.0 : 0.97)
            .animation(.default.speed(model.showFlow ? 1.0 : 2.0), value: model.showFlow)
            .animation(.default.speed(1.0), value: preventCrash)
        }
    }
    
    var FlowPicker: some View {
        Button(action: toggleFlowPicker) {
            VStack {
                PickerLabel(text: "Flow: ", time: (flow.flowMinutes * 60) + flow.flowSeconds, color: .myBlue)
                if chooseFlow {
                    MultiComponentPicker(columns: columns,selections: [$flow.flowMinutes, $flow.flowSeconds])
                }
            }
            .animation(.default.speed(chooseFlow ? 0.6 : 2.0), value: chooseFlow)
        }
    }
    
    var BreakPicker: some View {
        Button(action: toggleBreakPicker) {
            VStack {
                PickerLabel(text: "Break:", time: (flow.breakMinutes * 60) + flow.breakSeconds, color: .gray)
                if chooseBreak {
                    MultiComponentPicker(columns: columns,selections: [$flow.breakMinutes, $flow.breakSeconds])
                }
            }
            .animation(.default.speed(chooseBreak ? 0.6 : 2.0), value: chooseBreak)
        }
    }
    
    var RoundsPicker: some View {
        Button(action: toggleRoundsPicker) { RoundsLabel }
            .animation(.default.speed(chooseRound ? 0.6 : 2.0), value: chooseRound)
            .padding(.bottom, 4)
    }
    
    var flowSheetMenu: some View {
        Menu {
            Button(action: Delete) {
                Text("Delete") }
        } label: {
            Image(systemName: "ellipsis")
                .font(.title3)
                .foregroundColor(.myBlue)
                .CircularGlassButton()
        }
    }
    
    var FlowTitle: some View {
        TextField("Title", text: $flow.title)
            .font(.title)
            .foregroundColor(.white.opacity(0.5))
            .focused($focusedField, equals: .flowName)
            .onAppear {
                if flow.new {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { focusedField = .flowName }
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
    
    var RoundsLabel: some View {
        VStack {
            HStack {
                Text("Rounds:")
                    .font(.headline)
                Text("\(flow.rounds)")
            }
            .foregroundColor(.white.opacity(0.8))
            .frame(maxWidth: .infinity, alignment: .leading)
            if chooseRound {
                PickerView(selection: $flow.rounds, unit: rounds, label: "")
            }
        }
    }
    
    func Delete() {
        model.showFlow = false;
        preventCrashFunc()
        model.deleteFlow(id: flow.id)
    }
    
    func toggleFlowPicker() {
        chooseFlow.toggle()
        chooseBreak = false
        chooseRound = false
        preventCrash.toggle()
    }
    func toggleBreakPicker() {
        chooseBreak.toggle()
        chooseFlow = false
        chooseRound = false
        preventCrash.toggle()
    }
    func toggleRoundsPicker() {
        chooseRound.toggle()
        chooseFlow = false
        chooseBreak = false
        preventCrash.toggle()
    }
    
    func Save() {
        preventCrashFunc()
            model.showFlow = false;
            if flow.new {
                model.addFlow(flow: flow)
                model.selection = (model.flowList.count - 1)
            } else {
                model.editFlow(id: flow.id, flow: flow)
            }
    }
    
    func preventCrashFunc() {
        chooseFlow = false
        chooseBreak = false
        chooseRound = false
        flow.blocks.indices.forEach {
            flow.blocks[$0].pickTime = false
        }
        preventCrash.toggle()
    }
    
    @State var segmentSize: CGSize = .zero
    let items = ["Simple", "Custom"]
    
    private var activeSegmentView: AnyView {
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
        return
            RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.black.opacity(0.55))
            .frame(width: self.segmentSize.width, height: self.segmentSize.height)
            .offset(x: CGFloat(flow.simple ? 0 : 1) * (self.segmentSize.width + 16 / 2), y: 0)
            .eraseToAnyView()
    }
    
    var SegmentedPicker: some View {
        ZStack(alignment: .leading) {
            activeSegmentView
            HStack {
                FootNote(text: "Simple")
                    .foregroundColor(flow.simple == true ? .white.opacity(0.95) : .white.opacity(0.95))
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                    .onTapGesture {
                        flow.simple = true;
                        preventCrashFunc()
                    }
                FootNote(text: "Custom")
                    .foregroundColor(flow.simple == false ? .white.opacity(0.95) : .white.opacity(0.95))
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                    .onTapGesture {
                        flow.simple = false
                        preventCrashFunc()
                    }
            }
        }
        .animation(.easeOut(duration: 0.3), value: flow.simple)
        .padding(3.0)
        .background(.ultraThinMaterial.opacity(0.55))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.bottom, 8)
    }
}

struct PickerLabel: View {
    var text: String
    var time: Int
    var color: Color
    
    var body: some View {
        HStack {
            Headline(text: text)
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
                ForEach(unit, id: \.self) { unit in
                    Text("\(unit) \(label)")
                }
            }
            .pickerStyle(.wheel)
        }
        .frame(height: 150)
        .padding(.vertical, -8)
    }
}

struct MultiComponentPicker<Tag: Hashable>: View  {
    let columns: [Column]
    var selections: [Binding<Tag>]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
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
                        .clipped()
                        .padding(.vertical, -8)
                    }
                }
            }
        }
        .frame(height: 150)
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

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                .clear
                .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}
struct SizeAwareViewModifier: ViewModifier {
    @Binding var viewSize: CGSize
    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }
    
    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

