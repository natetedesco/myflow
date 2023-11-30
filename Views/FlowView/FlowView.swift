//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @State var model: FlowModel
    @FocusState var focusedBlockID: UUID?
    @State var flowDetent = PresentationDetent.large
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.4).ignoresSafeArea()
        
        NavigationStack {
            
            VStack {
                
                Text("Total: " + model.flow.totalFlowTimeFormatted())
                    .font(.footnote)
                    .foregroundStyle(.secondary)
//                    .fontWeight(.medium)
//                    .padding(.top, 8)
                    .leading()
                    .padding(.leading)
                
                
                Divider()
                    .padding(.leading)
                
                // Blocks
                ScrollView {
                    
                    if model.flow.blocks.count == 0 {
                        VStack {
                            Spacer()
                            Text("No Focus")
                                .font(.title2)
                            Spacer()
                        }
                    } else {
                        
                        VStack {
                            ForEach($model.flow.blocks) { $block in
                                BlockView(model: model, block: $block)
                                //                                    .focused($focusedBlockID, equals: block.id)
                                    .dragAndDrop(
                                        model: model,
                                        block: $block,
                                        draggingItem: $model.draggingItem,
                                        dragging: $model.dragging,
                                        blocks: $model.flow.blocks)
                                
                                Divider()
                                    .padding(.leading)
                            }
                            .animation(.default, value: model.flow.blocks)
                        }
//                        .padding(.top, 8)
                        
                        
                    }
                }
                .customOnDrop(
                    model: model,
                    draggingItem: $model.draggingItem,
                    items: $model.flow.blocks,
                    dragging: $model.dragging
                )
            }
            .navigationTitle(model.flowList[model.selection].title)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    
                    if model.mode == .initial {
                        
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.down")
                                    .fontWeight(.semibold)
                                    .padding(.trailing, -4)
                                Text("Flows")
                            }
                            .padding(.leading, -12)
                        }
                    } else {
                        Button {
                            model.Reset()
                            dismiss()
                        } label: {
//                            Text("Reset")
                            Image(systemName: "gobackward")
                                .foregroundColor(.myColor)
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                        
                        HStack {
                            if model.mode == .initial {
                                
                                Button {
                                    lightHaptic()
                                    model.showBlock.toggle()
                                    model.addBlock()
                                    
                                    if let lastBlock = model.flow.blocks.last {
                                        focusedBlockID = lastBlock.id
                                        model.selectedIndex = model.flow.blocks.count - 1
                                    }
                                    
                                } label: {
                                    Image(systemName: "plus")
                                        .fontWeight(.semibold)
                                        .font(.title2)
                                    //                                .padding(12)
                                        .foregroundStyle(.teal)
                                    //                                .background(Circle().foregroundStyle(.teal))
                                    //                                .padding(.trailing, -4)
                                }
                            } else {
                                
                                Button {
                                    model.Skip()
                                    softHaptic()
                                } label: {
                                    Text("Complete")
                                        .foregroundColor(.myColor)
//                                        .font(.footnote)
                                }
                                
                                
                            }
                            
                            
                            Spacer()
                            
                            
                            // Add Block
                            Button {
                                softHaptic()
                                model.Start()
                            } label: {
                                Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                                    .font(.title3)
                                    .padding()
                                    .foregroundStyle(.teal)
                                    .background(Circle().foregroundStyle(.teal.quinary))
                                                                    .padding(.trailing, -4)
                                
                            }
                            
                        }
                        .padding(.top, 4)
                        
//                    }
//                    else {
//                        Button {
//                            model.showFlowRunning.toggle()
//                        } label: {
//                            
//                            Gauge(value: formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft)) {
//                                
//                            } currentValueLabel: {
//                                Text(formatTime(seconds: model.flowTimeLeft))
//                                    .foregroundStyle(.white)
//                            }
//                            .gaugeStyle(.accessoryCircularCapacity)
//                            .tint(.accentColor)
//                        }
//                        .padding(.bottom, -4)
//                    }
                }
            }
            
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(.keyboard)
            .customOnDrop(model: model, draggingItem: $model.draggingItem, items: $model.flow.blocks, dragging: $model.dragging)
            .navigationBarBackButtonHidden(model.mode == .flowRunning ? true : false)
            
        }
    }
        .sheet(isPresented: $model.showBlock) {
            BlockSheetView(model: model)
                .accentColor(.teal)
                .presentationCornerRadius(32)
                .presentationDetents([.fraction(1/3)])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationBackground(.regularMaterial)
                .presentationDragIndicator(.hidden)
        }
        
        .fullScreenCover(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model, detent: $flowDetent)
        }
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
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showPayWall") var showPayWall = false
    
    @State var showStatistics = false
    @State var showSettings = false
    @State var showAppBlocker = false
    @State var showPaywall = false
    
    @State var size: CGFloat = .zero
    
    @Environment(\.dismiss) var dismiss
}

struct BlockSheetView: View {
    @State var model: FlowModel
    
    @State var blockText = ""
    @State private var selectedOption = 0
    let options = ["Focus", "Break"]
    
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            NavigationStack {
                VStack {
                    HStack {
                        TextField("Block Title", text: $blockText)
                            .leading()
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                            .onSubmit {
                                model.showBlock.toggle()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(.regularMaterial)
                            .cornerRadius(16)
                        
                        Button {
                            dismiss()
                        } label: {
                            
                            Image(systemName: "xmark")
                                .font(.callout)
                                .foregroundStyle(.white.tertiary)
                                .padding(12)
                                .background(Circle().foregroundStyle(.ultraThinMaterial))
                        }
                    }
                    
                    MultiComponentPicker(columns: columns, selections: [
                        $model.flow.blocks[model.selectedIndex].hours,
                        $model.flow.blocks[model.selectedIndex].minutes,
                        $model.flow.blocks[model.selectedIndex].seconds]
                    )
                    .padding(.vertical, -12)
                    
                    Button {
                        dismiss()
                    } label : {
                        Text("Add Block")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.teal)
                            .cornerRadius(16)
                            .padding(.bottom)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
    }
}
