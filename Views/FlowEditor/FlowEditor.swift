//
//  FlowView2.swift
//  MyFlow
//  Created by Nate Tedesco on 8/21/23.
//

import SwiftUI

struct FlowView2: View {
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @ObservedObject var model: FlowModel
    @Binding var flow: Flow
    
    @State var updateView = false
    @State var rename = false
    
    @State var selectedIndex = 0
    @State var selectedBlock = false // Loads the editor in the state
    @State var showBlockEditor = false // delayed and fades in
    @State var draggingItem: Block?
    @State var dragging = false
    
    @FocusState var focusedField: Field?
    @Environment(\.dismiss) var dismiss
    
    @State private var showingSheet = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    ScrollView {
                        if model.showFlow || rename {
                            
                            // Title textfield
                            TextField("Flow", text: $model.flow.title)
                                .font(.largeTitle.bold())
                                .padding(.leading)
                                .padding(.top, 3)
                                .padding(.bottom, -1)
                                .focused($focusedField, equals: .flowName)
                                .keyboardType(.alphabet)
                                .disableAutocorrection(true)
                                .onAppear {
                                    focusedField = .flowName
                                }
                                .onSubmit {
                                    if !rename {
                                        if model.flow.title.isEmpty {
                                            model.flow.title = "Flow"
                                        }
                                        model.showFlow = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                                            updateView.toggle()
                                        }
                                    }
                                    rename = false
                                }
                        }
                        
                        // Blocks
                        VStack {
                            ForEach(Array(flow.blocks.enumerated()), id: \.element.id) { index, block in
                                BlockView(flow: $flow, index: index, block: $flow.blocks[index], selectedBlock: $selectedBlock, showBlockEditor: $showBlockEditor, selectedIndex: $selectedIndex)
                                    .dragAndDrop(block: $flow.blocks[index], draggingItem: $draggingItem, dragging: $dragging, blocks: $flow.blocks)
                            }.animation(.default, value: flow.blocks)
                                .disabled(focusedField == .flowName)
                        }
                        .padding(.top) // must apply padding here to seperate from title
                        
                        Text(flow.totalFlowTimeFormatted())
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.3))
                            .padding(.top, 8)
                            .monospacedDigit()
                        
                    }
                    Spacer()
                    
                    // ToolBar
                    HStack {
                        addBreakButton
                        
                        Spacer()
                        if !proAccess {
                            Button {
                                showingSheet = true
                            } label: {
                                Image(systemName: "camera.filters")
                                    .font(.title2)
                                    .myBlue()
                            }
                        }
                        Spacer()
                        addFlowButton
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 8)
                }
                // Navigation Title and Toolbar
                .navigationBarTitle(model.showFlow || rename ? "" : flow.title)
                .toolbar {
                    if !showBlockEditor {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            HStack {
                                Menu {
                                    RenameButton
                                    Divider()
                                    DeleteFlowButton
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.footnote)
                                        .foregroundColor(.myBlue)
                                    //                                        .CircularGlassButton()
                                }
                                if !model.showFlow {
                                    doneButton
                                }
                            }
                        }
                        ToolbarItem(placement: .keyboard) {
                            if model.showFlow {
                                HStack {
                                    Button("Cancel") {
                                        model.showFlow = false
                                        model.showingSheet = false
                                        model.deleteFlow(id: model.flow.id)
                                    }.foregroundColor(.gray)
                                    Spacer()
                                    Button("Save") {
                                        if !rename {
                                            if model.flow.title.isEmpty {
                                                model.flow.title = "Flow"
                                            }
                                            model.showFlow = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                                                updateView.toggle()
                                            }
                                        }
                                        rename = false
                                    }.foregroundColor(.myBlue)
                                }
                            }
                            if rename {
                                Button("Save") {
                                    rename = false
                                    model.showFlow = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                                        updateView.toggle()
                                    }
                                }.foregroundColor(.myBlue)
                            }
                        }
                    }
                }
                .customOnDrop(draggingItem: $draggingItem, items: $flow.blocks, dragging: $dragging)
                .background(AnimatedBlur(opacity: 0.3).ignoresSafeArea()) // prevents it from moving when renaming
                .background(.ultraThinMaterial.opacity(0.5))
                .ignoresSafeArea(.keyboard)
            }
            .customOnDrop(draggingItem: $draggingItem, items: $flow.blocks, dragging: $dragging)
            
            // Block Editor
            if selectedBlock {
                ZStack {
                    // BackGround
                    Color.clear.opacity(0.0).ignoresSafeArea()
                        .background(.ultraThinMaterial)
                        .onTapGesture {
                            lightHaptic()
                            selectedBlock = false
                            showBlockEditor = false
                            if flow.blocks[selectedIndex].title.isEmpty {
                                flow.blocks[selectedIndex].title = flow.blocks[selectedIndex].flow ? "Focus" : "Break"
                            }
                        }
                        .opacity(showBlockEditor ? 1.0 : 0.0)
                        .animation(.default.speed(3.0), value: showBlockEditor)
                    
                    // Block Editor
                    BlockEditingView(model: model, flow: $flow, index: $selectedIndex, selectedBlock: $selectedBlock, showBlockEditor: $showBlockEditor)
                        .padding(.bottom, 200)
                        .opacity(showBlockEditor ? 1.0 : 0.01)
                        .scaleEffect(showBlockEditor ? 1.0 : 0.97)
                        .animation(.default.speed(2.0), value: showBlockEditor)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Button("Save") {
                                    if flow.blocks[selectedIndex].title.isEmpty {
                                        flow.blocks[selectedIndex].title = flow.blocks[selectedIndex].flow ? "Focus" : "Break"
                                    }
                                    model.save()
                                    selectedBlock = false
                                    showBlockEditor = false
                                }.foregroundColor(.myBlue)
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            if !proAccess {
                PayWall()
            } else {
//                FlowControls(model: model)
//                    .presentationDetents([.fraction(1/3), .medium])
//                    .presentationBackground(.thickMaterial)
//                    .presentationCornerRadius(20)
//                    .presentationDragIndicator(.hidden)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    var addBreakButton: some View {
        Button {
            lightHaptic()
            flow.addBreakBlock()
            selectedIndex = flow.blocks.endIndex - 1
            selectedBlock = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                showBlockEditor = true
            }        } label: {
                AddButtonLabel(color: .gray)
            }
    }
    
    var addFlowButton: some View {
        Button {
            lightHaptic()
            flow.addFlowBlock()
            selectedIndex = flow.blocks.endIndex - 1
            selectedBlock = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                showBlockEditor = true
            }
        } label: {
            AddButtonLabel(color: .myBlue)
        }
    }
    
    struct AddButtonLabel: View {
        var color: Color
        
        var body: some View {
            Image(systemName: "plus")
                .font(.title)
                .padding(12)
                .background(Circle()
                    .fill(.ultraThinMaterial.opacity(0.55)))
                .foregroundColor(color)
        }
    }
    
    var doneButton: some View {
        Button {
            mediumHaptic()
            dismiss()
            model.saveFlow(id: flow.id, flow: flow)
        } label: {
            Text("Done")
                .foregroundColor(.myBlue)
                .fontWeight(.medium)
        }
    }
    
    var RenameButton: some View {
        Button {
            rename = true
        } label: {
            Label("Rename", systemImage: "pencil")
        }
    }
    
    var DeleteFlowButton: some View {
        Button(role: .destructive) {
            model.deleteFlow(id: model.flow.id)
            model.showingSheet = false
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}

struct FlowView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Field: Hashable {
    case flowName
    case blockName
    case time
}

extension Flow {
    func totalFlowTimeInSeconds() -> TimeInterval {
        var totalSeconds: TimeInterval = 0
        
        for block in blocks {
            totalSeconds += block.totalTimeInSeconds
        }
        return totalSeconds
    }
    
    func totalFlowTimeFormatted() -> String {
        let totalSeconds = totalFlowTimeInSeconds()
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60
        
        var formattedTime = ""
        if hours > 0 {
            formattedTime += "\(hours):"
        }
        formattedTime += String(format: "%02d:%02d", minutes, seconds)
        
        return formattedTime
    }}

extension Block {
    var totalTimeInSeconds: TimeInterval {
        let totalSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        return totalSeconds
    }
}

import FamilyControls

//struct FlowControls: View {
//    @AppStorage("ProAccess") var proAccess: Bool = false
//
//    @Environment(\.dismiss) var dismiss
//
//    let center = AuthorizationCenter.shared
//    @AppStorage("ScreenTimeAuthorized") var isAuthorized: Bool = false
//    @State var isPresented = false
//    @ObservedObject var model: FlowModel
//    @StateObject var settings = Settings()
//    @State private var showingSheet = false
//
//    var body: some View {
//        NavigationView {
//
//            List {
//                Text("Category")
//                    .listRowBackground(Color.black.opacity(0.6))
//
//
//                Section {
//                    FlowPicker
//                        .listRowBackground(Color.black.opacity(0.6))
//                    BreakPicker
//                        .listRowBackground(Color.black.opacity(0.6))
//                }
//
//            }
//            .scrollContentBackground(.hidden)
//            .navigationTitle("Advanced")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(leading:
//                                    Button { dismiss()
//            } label: {
//                Text("Cancel")
//                    .foregroundColor(.gray)
//            }
//            )
//            .navigationBarItems(trailing:
//                                    Button { dismiss()
//            } label: {
//                Text("Save")
//                    .foregroundColor(.myBlue)
//            }
//            )
//        }
//    }
//
//    @State var chooseFlow = false
//    var FlowPicker: some View {
//        Button(action: toggleFlowPicker) {
//            VStack {
//                HStack {
//                    Text("Focus blocks")
//                        .foregroundColor(.white)
//                    Spacer()
//                    Text(formatTime(seconds: (model.flow.blocks[0].minutes * 60) + model.flow.blocks[0].seconds))
//                        .foregroundColor(.gray)
//                }
//
//                .leading()
//                if chooseFlow {
//                    MultiComponentPicker(columns: columns, selections: [$model.flow.blocks[0].hours, $model.flow.blocks[0].minutes, $model.flow.blocks[0].seconds])
//                }
//            }
//        }
//    }
//
//    @State var chooseBreak = false
//    var BreakPicker: some View {
//        Button(action: toggleFlowPicker) {
//            VStack {
//                HStack {
//                    Text("Break blocks")
//                        .foregroundColor(.white)
//                    Spacer()
//                    Text(formatTime(seconds: (model.flow.blocks[0].minutes * 60) + model.flow.blocks[0].seconds))
//                        .foregroundColor(.gray)
//                }
//
//                .leading()
//                if chooseFlow {
//                    MultiComponentPicker(columns: columns, selections: [$model.flow.blocks[0].hours, $model.flow.blocks[0].minutes, $model.flow.blocks[0].seconds])
//                }
//            }
//        }
//    }
//
//    func toggleFlowPicker() {
//        chooseFlow.toggle()
//        chooseBreak = false
//    }
//    func toggleBreakPicker() {
//        chooseBreak.toggle()
//        chooseFlow = false
//    }
//
//}
