//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showPayWall") var showPayWall = false
    
    @State var model: FlowModel
    
    @State var showStatistics = false
    @State var showSettings = false
    @State var showAppBlocker = false
    @State var showPaywall = false
    
    @State var flowDetent = PresentationDetent.large
    @State var size: CGFloat = .zero
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focusedBlockID: UUID?
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    
                    // Blocks
                    ScrollView {
                        
                        Text(model.flow.totalFlowTimeFormatted())
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .leading()
                            .padding(.leading)
                            .padding(.bottom )
                        
                        if model.flow.blocks.count == 0 {
                            VStack {
                                Spacer()
                                Text("No Focus")
                                    .font(.title2)
                                Spacer()
                            }
                        } else {
                            
                            ForEach($model.flow.blocks) { $block in
                                BlockView(model: model, block: $block)
                                    .focused($focusedBlockID, equals: block.id)
                                    .dragAndDrop(
                                        model: model,
                                        block: $block,
                                        draggingItem: $model.draggingItem,
                                        dragging: $model.dragging,
                                        blocks: $model.flow.blocks)
                                
                                Divider()
                                    .padding(.leading, 32)
                            }
                            .animation(.default, value: model.flow.blocks)
                        }
                        
                    }
                    .customOnDrop(
                        model: model,
                        draggingItem: $model.draggingItem,
                        items: $model.flow.blocks,
                        dragging: $model.dragging
                    )
                    
                    // Time Picker
                    if model.blockSelected {
                        Spacer()
                        
                        VStack {
                            MultiComponentPicker(columns: columns, selections: [
                                $model.flow.blocks[model.selectedIndex].hours,
                                $model.flow.blocks[model.selectedIndex].minutes,
                                $model.flow.blocks[model.selectedIndex].seconds]
                            )
                            .padding(.vertical, 4)
                        }
                        .background(.regularMaterial)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .padding(.top, -8)
                        .animation(.default.speed(0.5), value: model.blockSelected)
                    }
                    
                }
                .navigationTitle(model.flowList[model.selection].title)
                
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            
                            // Add Block
                            if model.mode == .initial {
                                Button {
                                    model.addBlock()
                                    lightHaptic()
                                    if let lastBlock = model.flow.blocks.last {
                                        focusedBlockID = lastBlock.id
                                        model.selectedIndex = model.flow.blocks.count - 1
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "plus")
                                            .font(.title2)
                                            .fontWeight(.medium)
                                            .padding(10)
                                            .background(Circle().foregroundStyle(.ultraThinMaterial))
                                            .padding(.leading, -6)
                                    }
                                }
                            } 
//                            else {
//                                Button {
//                                    model.Skip()
//                                } label: {
//                                    HStack {
//                                        Image(systemName: "goforward")
//                                            .font(.title3)
//                                        Text("Complete")
//                                            .fontWeight(.semibold)
//                                    }
//                                }
//                            }
                            
                            Spacer()
                            
                            // Start Flow
                            Button {
                                softHaptic()
                                model.Start()
                            } label: {
                                Text("Start Flow")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if model.mode == .initial && !model.blockSelected {
                            
                            Button {
                                dismiss()
                            } label: {
                                Text("Done")
                                    .foregroundStyle(Color.myColor)
                            }
                        }
                    }
                    ToolbarItemGroup(placement: .topBarLeading) { // Top Bar
                        
                        if model.mode != .initial && flowDetent != .large {
                            Button {
                                model.Reset()
                            } label: {//
                                Text("Reset")
                                    .foregroundColor(.myColor)
                            }
                        }
                    }
                }
            }
        }
        .customOnDrop(model: model, draggingItem: $model.draggingItem, items: $model.flow.blocks, dragging: $model.dragging)
        
        .sheet(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model, detent: $flowDetent)
                .presentationBackground(.bar)
                .presentationDetents([.height(80), .large], selection: $flowDetent)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationCornerRadius(40)
                .interactiveDismissDisabled()
        }
        
        //            .sheet(isPresented: $showPaywall) {
        //                PayWall()
        //                    .presentationCornerRadius(40)
        //                    .presentationBackground(.bar)
        //                    .presentationDragIndicator(.visible)
        //            }
    }
    
    var startLabel: String {
        switch model.mode {
        case .initial: "Start"
        case .flowStart: ("Start " + model.flow.blocks[model.blocksCompleted].title)
        case .flowRunning: "Pause"
        case .flowPaused: "Start"
        case .completed: "Start"
        }
    }
}


extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)

        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
//        .withDesign(.rounded)


        return self
    }
}
