//
//  FlowView2.swift
//  MyFlow
//  Created by Nate Tedesco on 8/21/23.
//

import SwiftUI

struct FlowView2: View {
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
                        }
                        .padding(.top) // must apply padding here to seperate from title
                    }
                    Spacer()
                    
                    // ToolBar
                    HStack {
                        addBreakButton
                        Spacer()
                        addFlowButton
                    }
                    .padding(.horizontal, 32)
                    .padding(.top)
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
                .background(.ultraThinMaterial.opacity(0.75))
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
                AddButtonLabel(title: "plus", color: .gray)
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
            AddButtonLabel(title: "plus", color: .myBlue)
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

struct AddButtonLabel: View {
    var title: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .font(.largeTitle)
                .CircularGlassButton()
        }
        .foregroundColor(color)
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

extension View {
    func customOnDrop(draggingItem: Binding<Block?>, items: Binding<[Block]>, dragging: Binding<Bool>) -> some View {
        self.onDrop(of: [.item], delegate: DropViewDelegate(currentItem: draggingItem.wrappedValue ?? Block(), items: items, draggingItem: draggingItem, dragging: dragging))
    }
    
    func dragAndDrop(block: Binding<Block>, draggingItem: Binding<Block?>, dragging: Binding<Bool>, blocks: Binding<[Block]>) -> some View {
        self
            .contentShape([.dragPreview], CornerShape(radius: 25, corners: [.allCorners]))
            .opacity(block.wrappedValue.id == draggingItem.wrappedValue?.id && dragging.wrappedValue ? 0.001 : 1)
            .drag(if: block.wrappedValue.draggable) {
                heavyHaptic()
                draggingItem.wrappedValue = block.wrappedValue
                return NSItemProvider(contentsOf: URL(string: "\(block.wrappedValue.id)"))!
            }
            .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: block.wrappedValue, items: blocks, draggingItem: draggingItem, dragging: dragging))
    }
}
