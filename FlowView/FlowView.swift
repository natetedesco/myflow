//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
// This is crazy
//

import SwiftUI
import TipKit

struct FlowView: View {
    @State var model: FlowModel
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var showPayWall = false
    @State var showDistractionBlocker = false
    @State var showRateTheApp = false
    
    
    @State var newBlock = false
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: HStack {
                    // Block Count
                    Text("^[\(model.flow.blocks.count) Block](inflect: true)")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    Spacer()
                    
                    // Total Flow Time
                    Text(model.flow.totalFlowTimeFormatted())
                        .fontWeight(.medium)
                        .font(.footnote)
                }) {
                    
                    // Complete Tip
                    if model.mode == .flowStart {
                        TipView(completeTip, arrowEdge: .bottom).listRowSeparator(.hidden, edges: [.top])
                    }
                    
                    // Blocks
                    ForEach($model.flow.blocks) { $block in
                        Button {
                            if model.mode == .initial {
                                if let selectedBlockIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                                    model.selectedBlockIndex = selectedBlockIndex
                                    model.showBlock.toggle()
                                }
                            }
                        } label: {
                            BlockView(model: model, block: $block)
                                .padding(.vertical, sizeClass == .regular ? 16 : -4)
                        }
                        .swipeActions(edge: .leading) {
                            if model.mode == .initial {
                                Button {
                                    model.duplicateBlock(block: block)
                                    blockControlTip.invalidate(reason: .actionPerformed)
                                } label: {
                                    Text("Duplicate")
                                }
                                .tint(.teal)
                            } else if model.mode == .flowRunning && currentBlock(block: block) {
                                Button {
                                    model.Complete()
                                } label: {
                                    if model.flowExtended { Text("Done")
                                    } else {
                                        Text("Complete")
                                    }
                                }
                                .tint(.teal)
                            } else if model.mode == .flowStart && completedBlock(block: block) {
                                Button {
                                    model.extend()
                                } label: {
                                    Text("Extend")
                                }
                                .tint(.teal)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            if (model.mode != .initial && model.mode != .flowStart && (currentBlock(block: block)) || completedBlock(block: block)) {
                                Button {
                                    model.resetBlock()
                                } label: {
                                    Text("Reset")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .onDelete(perform: model.mode == .initial ? delete : nil)
                    .onMove(perform: move)
                }
                
                // Blocks Tip
                TipView(blocksTip, arrowEdge: .none)
                    .listRowSeparator(.hidden, edges: [.bottom])
                
                // Block Control Tip
                if model.flow.blocks.count >= 1 { // causes sheet glitch when opening flow
                    TipView(blockControlTip, arrowEdge: .top)
                        .listRowSeparator(.hidden, edges: [.bottom])
                }
            }
            .animation(.default, value: model.flow.blocks)
            .listStyle(.plain)
            .navigationTitle(model.flow.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            if model.mode == .initial {
                                showDistractionBlocker.toggle()
                            } else {
                                lightHaptic()
                            }
                        } label: {
                            Image(systemName: model.settings.blockDistractions ? "shield.fill" : "shield")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(6)
                                .background(Circle().foregroundStyle(.ultraThinMaterial))
                        }
                        
                        //                        Button {
                        //                        } label: {
                        //                            Image(systemName: "ellipsis")
                        //                                .font(.caption)
                        //                                .fontWeight(.bold)
                        //                                .padding(12)
                        //                                .background(Circle().foregroundStyle(.ultraThinMaterial))
                        //                                .padding(.horizontal, -6)
                        //                        }
                        
                    }
                    
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    if model.mode == .initial {
                        doneButton
                    }
                    else {
                        resetButton
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        
                        // Left
                        if model.mode != .breakRunning && model.mode != .breakPaused {
                            startButton
                        } else {
                            breakLabel
                        }
                        
                        Spacer()
                        
                        // Right
                        if model.mode == .initial {
                            plusButton
                        } else if model.mode == .flowStart {
                            breakButton
                        } else if model.mode != .breakRunning && model.mode != .breakPaused {
                            focusViewButton
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(model.mode == .flowRunning ? true : false)
        }
        
        // Flow Running
        .fullScreenCover(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model)
        }
        
        // Block Sheet
        .sheet(isPresented: $model.showBlock) {
            BlockSheetView(model: model,
                           newBlock: $newBlock,
                           title: newBlock ? "" : model.flow.blocks[model.selectedBlockIndex].title,
                           minutes: newBlock ? 20 : model.flow.blocks[model.selectedBlockIndex].minutes,
                           seconds: newBlock ? 0 : model.flow.blocks[model.selectedBlockIndex].seconds
            )
            .sheetMaterial()
            .presentationDetents([.fraction(1/3)])
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
        }
        
        // DistractionBlocker
        .sheet(isPresented: $showDistractionBlocker) {
            DistractionBlocker(model: model)
                .sheetMaterial()
                .presentationDragIndicator(.hidden)
                .presentationDetents([.medium])
        }
        
        // Flow Completed
        .sheet(isPresented: $model.showFlowCompleted) {
            FlowCompletedView(model: model, showRateTheApp: $showRateTheApp)
                .sheetMaterial()
                .presentationDetents([.fraction(4/10)])
        }
        
        // Paywall
        .sheet(isPresented: $showPayWall) {
            PayWall(detent: $model.detent)
                .sheetMaterial()
                .presentationDetents([.large, .fraction(6/10)], selection: $model.detent)
                .interactiveDismissDisabled(model.detent == .large)
                .presentationDragIndicator(.hidden)
                .presentationBackgroundInteraction(.enabled)
        }
        .sheet(isPresented: $showRateTheApp) {
            AskForRating()
                .sheetMaterial()
                .presentationDetents([.fraction(3/10)])
        }
    }
    
    // Done
    var doneButton: some View {
        Button {
            model.saveFlow()
            dismiss()
        } label: {
            Text("Done")
        }
    }
    
    // Reset
    var resetButton: some View {
        Button {
            model.Reset()
        } label: {
            Text("Reset")
        }
    }
    
    // Start
    var startButton: some View {
        Button {
            softHaptic()
            model.Start()
            blocksTip.invalidate(reason: .actionPerformed)
            if model.mode == .flowStart {
                completeTip.invalidate(reason: .actionPerformed)
            }
        } label: {
            Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                .font(.title3)
                .padding()
                .background(Circle().foregroundStyle(.teal.quinary))
                .padding(.leading, -8)
        }
    }
    
    // Plus
    var plusButton: some View {
        Button {
            newBlock.toggle()
            model.showBlock.toggle()
            blocksTip.invalidate(reason: .actionPerformed)
            if model.flow.blocks.count >= 1 { // causes sheet glitch when opening flow
                blockControlTip.invalidate(reason: .actionPerformed)
            }
        } label: {
            Text("Add Focus")
                .fontWeight(.medium)
        }
    }
    
    var focusViewButton: some View {
        // Focus View Toggle
        Button {
            model.showFlowRunning.toggle()
            lightHaptic()
        } label: {
            Image(systemName: "circle")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.teal)
                .padding(6)
                .background(Circle().foregroundStyle(.regularMaterial))
                .padding(.trailing, -8)
        }
    }
    
    // Break
    let values = [30, 20, 15, 10, 5, 2, 1]
    var breakButton: some View {
        Menu {
            Section(header: Text("Select to Start")) {
                ForEach(values, id: \.self) { i in
                    Button {
                        if proAccess {
                            model.breakTime = i * 60
                            model.startBreak()
                        } else {
                            showPayWall.toggle()
                        }
                        softHaptic()
                    } label: {
                        Text("\(i) min")
                    }
                }
            }
        } label: {
            HStack {
                Text("Break")
                    .fontWeight(.medium)
                    .font(.footnote)
            }
            .foregroundStyle(.white.opacity(0.8))
            .padding(19.5)
            .background(Circle().foregroundStyle(.ultraThinMaterial))
        }
        .padding(.trailing, -16)
    }
    
    var breakLabel: some View {
        HStack {
            Menu {
                Button {
                    model.endBreak()
                } label: {
                    Text("End Break")
                }
                if model.mode == .breakRunning {
                    Button {
                        model.pauseBreak()
                    } label: {
                        Text("Pause Break")
                    }
                } else {
                    Button {
                        model.startBreak()
                    } label: {
                        Text("Resume Break")
                    }
                }
            } label: {
                HStack {
                    Text("Break")
                        .font(.title3)
                        .foregroundStyle(.white)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8))
                        .fontWeight(.semibold)
                        .padding(.horizontal, -4)
                        .foregroundStyle(.white.secondary)
                }
            }
            
            Spacer()
            
            Text(formatTime(seconds: model.breakTimeLeft))
                .font(.title2)
                .fontWeight(.light)
                .foregroundStyle(.white.secondary)
                .monospacedDigit()
        }
    }
    
    func delete(at offsets: IndexSet) {
        model.flow.blocks.remove(atOffsets: offsets)
        model.saveFlow()
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.flow.blocks.move(fromOffsets: source, toOffset: destination)
        model.saveFlow()
    }
    
    func currentBlock(block: Block) -> Bool {
        return model.flow.blocks.firstIndex(where: { $0.id == block.id }) == model.blocksCompleted
    }
    
    func completedBlock(block: Block) -> Bool {
        return model.flow.blocks.firstIndex(where: { $0.id == block.id }) == model.blocksCompleted - 1
    }
    
    // Tips
    var blocksTip = BlocksTip()
    var blockControlTip = BlockControlTip()
    var completeTip = CompleteTip()
    
}

#Preview {
    FlowView(model: FlowModel(mode: .initial, flow: Flow(title: "Flow", blocks: [Block(title: "Focus"), Block(title: "Focus")])))
}

#Preview {
    FlowView(model: FlowModel(mode: .flowStart, flow: Flow(title: "Flow", blocks: [Block(title: "Focus"), Block(title: "Focus")])))
}

#Preview {
    FlowView(model: FlowModel(mode: .flowRunning, flow: Flow(title: "Flow", blocks: [Block(title: "Focus"), Block(title: "Focus")])))
}
