//
//  FlowSheet.swift
//  MyFlow
//
//  Created by Nate Tedesco on 8/31/23.
//

import SwiftUI

struct FlowSheet: View {
    @ObservedObject var model: FlowModel
    
    @FocusState var focusedField: Field?
    
    @State var selectedIndex = 0
    @State var selectedBlock = false
    @State var showBlockEditor = false
    @State var draggingItem: Block?
    @State var dragging = false
    
    @State var showStatistics = false
    @State var showSettings = false
    @State var disable = false
    
    
    var body: some View {
        
        
        
        ZStack {
            if selectedBlock {
                BlockEditor
            } else {
                
                VStack {
                    
                    if !model.showFlowSheetAnimation {
                        Spacer()
                    }
                    
                    HStack  {
                        
                        Menu {
                            FlowList
                            CreateFlow
                            DeleteFlowButton
                            
                        } label: {
                            HStack {
                                Text(model.flow.title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 34))
                                    .fontWeight(.medium)
                                    .focused($focusedField, equals: .flowName)
                                    .onAppear {
                                        if model.newFlow {
                                            focusedField = .flowName
                                        }
                                    }
                                Image(systemName: "chevron.down")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.leading, 4)
                            }
                            .transaction { transaction in
                                transaction.animation = nil // disables ...
                            }
                            .disabled(model.mode != .Initial)
                        }
                        .onTapGesture {
                            disable = true
                        }
                        
                        
                        
                        Spacer()
                        
                        Text("Start")
                            .foregroundColor(.white)
                        
//                        Image(systemName: "play.fill")
//                            .foregroundStyle(.ultraThickMaterial)
//                            .environment(\.colorScheme, .light)
//                            .font(.title)

                        
                        
                    }
                    .padding(.top, 32)
                    .padding(.bottom)
                    .padding(.horizontal, 32)
                    
                    ScrollView {
                        ForEach(Array(model.flow.blocks.enumerated()), id: \.element.id) { index, block in
                            Button {
                                if let selectedBlockIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                                    selectedBlock = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                        showBlockEditor = true
                                    }
                                    selectedIndex = selectedBlockIndex
                                    softHaptic()
                                }
                            } label: {
                                
                                BlockView(model: model,
                                          flow: $model.flow,
                                          index: index,
                                          block: $model.flow.blocks[index],
                                          selectedBlock: $selectedBlock,
                                          showBlockEditor: $showBlockEditor,
                                          selectedIndex: $selectedIndex)
                                .dragAndDrop(block: $model.flow.blocks[index], draggingItem: $draggingItem, dragging: $dragging, blocks: $model.flow.blocks)
                                .disabled(focusedField == .flowName)
                            }
                        }
                        .animation(.default, value: model.flow.blocks)
                        
                        //                        .customOnDrop(draggingItem: $draggingItem, items: $model.flow.blocks, dragging: $dragging)
                        
                        
                    }
                    
                    // Fade out Scroll
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.999), endPoint: .bottom)
                    )
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [Color.white, Color.black.opacity(0)]), startPoint: UnitPoint(x: 0.5, y: 0.001), endPoint: .top)
                    )
                    .padding(.top, -8)
                    
                    Spacer()
                    
                    // ToolBar
                    HStack {

                        
                        
                        addBreakButton
                        
                        Spacer()
                        
                        addFlowButton
                        
                        
                    }
                    .padding(.horizontal, 32)
                    .customOnDrop(draggingItem: $draggingItem, items: $model.flow.blocks, dragging: $dragging)
                    
                }
                .padding(.horizontal, 8)
                //                .frame(maxWidth: .infinity, maxHeight: showFlowSheetAnimation ? .infinity : 16)
                .background(Color.clear)
                
            }
            //            .animation(.spring(response: 0.4), value: showFlowSheetAnimation)
        }
//        .FlowViewBackGround()
        .background(.ultraThinMaterial)
        .customOnDrop(draggingItem: $draggingItem, items: $model.flow.blocks, dragging: $dragging)
        .sheet(isPresented: $showStatistics) {
            StatsView()
                .presentationBackground(Color.clear)
        }
        
        .sheet(isPresented: $showSettings) {
            SettingsView(model: model)
                .presentationBackground(Color.clear)
        }
    }
    
    var addBreakButton: some View {
        Button {
            lightHaptic()
            model.flow.addBreakBlock()
            selectedIndex = model.flow.blocks.endIndex - 1
            selectedBlock = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                showBlockEditor = true
            }
        } label: {
            AddButtonLabel(color: .gray)
        }
    }
    
    var addFlowButton: some View {
        Button {
            lightHaptic()
            model.flow.addFlowBlock()
            selectedIndex = model.flow.blocks.endIndex - 1
            selectedBlock = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { // animation delay
                showBlockEditor = true
            }
        } label: {
            AddButtonLabel(color: .myColor)
        }
    }
    
    struct AddButtonLabel: View {
        var color: Color
        
        var body: some View {
            Image(systemName: "plus")
                .font(.system(size: 30))
            //                .fontWeight(.medium)
                .padding(12)
                            .background(Circle()
                                .fill(.thinMaterial))
//                .foregroundStyle(.ultraThickMaterial)
//                .environment(\.colorScheme, .light)
            
                            .foregroundColor(color)
        }
    }
    
    var CreateFlow: some View {
        Button {
            softHaptic()
            model.createFlow()
            model.showFlowSheet()
            disable = false
        } label: {
            Label("Create", systemImage: "plus")
        }
    }
    
    var EditFlowButton: some View {
        Button {
            model.showingFlowSheet = true
            disable = false
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
    
    
    var FlowList: some View {
        Picker("", selection: $model.selection) {
            ForEach(0..<$model.flowList.count, id: \.self) { i in
                Text(model.flowList[i].title)
                    .onChange(of: model.selection) { newValue in
                        disable = false
                    }
            }
        }
    }
    
    var DeleteFlowButton: some View {
        Button(role: .destructive) {
            model.deleteFlow(id: model.flow.id)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    var flowLengthLabel: some View {
        Text(model.flow.totalFlowTimeFormatted())
            .font(.footnote)
            .foregroundColor(.white.opacity(0.5))
            .monospacedDigit()
    }
    
    var BlockEditor: some View {
        ZStack {
            // BackGround
            Color.clear.opacity(0.0).ignoresSafeArea()
                .background(.ultraThinMaterial)
                .onTapGesture {
                    lightHaptic()
                    selectedBlock = false
                    showBlockEditor = false
                    if model.flow.blocks[selectedIndex].title.isEmpty {
                        model.flow.blocks[selectedIndex].title = model.flow.blocks[selectedIndex].flow ? "Focus" : "Break"
                    }
                }
                .opacity(showBlockEditor ? 1.0 : 0.0)
                .animation(.default.speed(3.0), value: showBlockEditor)
            
            // Block Editor
            BlockEditingView(
                model: model,
                flow: $model.flow,
                block: $model.flow.blocks[selectedIndex],
                index: $selectedIndex,
                selectedBlock: $selectedBlock,
                showBlockEditor: $showBlockEditor)
            .padding(.bottom, 256)
            .opacity(showBlockEditor ? 1.0 : 0.01)
            .scaleEffect(showBlockEditor ? 1.0 : 0.97)
            .animation(.default.speed(2.0), value: showBlockEditor)
            //            .toolbar {
            //                ToolbarItemGroup(placement: .keyboard) {
            //                    Button("Save") {
            //                        if model.flow.blocks[selectedIndex].title.isEmpty {
            //                            model.flow.blocks[selectedIndex].title = model.flow.blocks[selectedIndex].flow ? "Focus" : "Break"
            //                        }
            //                        model.save()
            //                        selectedBlock = false
            //                        showBlockEditor = false
            //                    }.foregroundColor(.myColor)
            //                }
            //            }
        }
    }
}

struct VScrollView<Content>: View where Content: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                content
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
            }
        }
    }
}
