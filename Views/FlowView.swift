//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI
import TipKit

struct FlowView: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @State var showPaywall = false
    @State var detent = PresentationDetent.large
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var selectedBreakTime = 5
    let values = [30, 20, 15, 10, 5, 2, 1]
    @State var newBlock = false
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: HStack {
                    Text("\(model.flow.blocks.count) Blocks")
                        .foregroundStyle(.white)
                    Spacer()
                    Text(model.flow.blocks.count == 0 ? "00:00" : model.flow.totalFlowTimeFormatted())
                        .font(.footnote)
                        .fontWeight(.medium)
                }) {
                    if model.mode != .initial {
                        TipView(completeTip, arrowEdge: .bottom)
                            .listRowSeparator(.hidden, edges: [.top])
                    }
                    ForEach($model.flow.blocks) { $block in
                        Button {
                            if model.mode == .initial {
                                if let selectedIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                                    model.selectedIndex = selectedIndex
                                    model.showBlock.toggle()
                                }
                            } else {
                                model.showFlowRunning.toggle()
                            }
                        } label: {
                            BlockView(model: model, block: $block)
                                .padding(.vertical, sizeClass == .regular ? 16 : -4)
                        }
                        .swipeActions(edge: .leading) {
                            if model.mode == .initial {
                                Button {
                                    model.duplicateBlock(block: block)
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
                            if model.mode != .initial && (currentBlock(block: block) || completedBlock(block: block)) {
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
                TipView(blocksTip, arrowEdge: .none)
                    .listRowSeparator(.hidden, edges: [.bottom])
            }
            .listStyle(.plain)
            .navigationTitle(model.flow.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {}
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    if !model.showBlock {
                        if model.mode == .initial {
                            doneButton
                        }
                        else {
                            resetButton
                        }
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
        .sheet(isPresented: $model.showBlock) {
            BlockSheetView(model: model, newBlock: $newBlock)
                .sheetMaterial()
                .presentationDetents([.fraction(1/3)])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showPaywall) {
            PayWall(detent: $detent)
                .presentationCornerRadius(32)
                .presentationBackground(.regularMaterial)
                .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                .interactiveDismissDisabled(detent == .large)
                .presentationDragIndicator(detent != .large ? .visible : .hidden)
                .presentationBackgroundInteraction(.enabled)
        }
        .fullScreenCover(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model)
        }
        .sheet(isPresented: $model.showFlowCompleted) {
            FlowCompletedView(model: model)
                .sheetMaterial()
                .presentationDetents([.fraction(4/10)])
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
        } label: {
            Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                .font(.title3)
                .padding()
                .background(Circle().foregroundStyle(.teal.quinary))
                .padding(.leading, -8)
        }
        //        .disabled(model.flow.blocks.count == 0)
    }
    
    // Plus
    var plusButton: some View {
        Button {
            lightHaptic()
            model.addBlock()
            model.showBlock.toggle()
            newBlock.toggle()
            blocksTip.invalidate(reason: .actionPerformed)
        } label: {
            HStack {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
    }
    
    var focusViewButton: some View {
        // Focus View Toggle
        Button {
            model.showFlowRunning.toggle()
        } label: {
            Image(systemName: "chevron.up")
                .font(.title3)
                .foregroundStyle(.white.tertiary)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
        }
    }
    
    // Break
    var breakButton: some View {
        Menu {
            Section(header: Text("Select to Start")) {
                ForEach(values, id: \.self) { i in
                    Button {
                        if proAccess {
                            model.breakTime = i * 60
                            model.startBreak()
                        } else {
                            showPaywall.toggle()
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
                    .font(.footnote)
            }
            .foregroundStyle(.white.secondary)
            .padding(19.5)
            .background(Circle().foregroundStyle(.regularMaterial))
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
    
    var blocksTip = BlocksTip()
    struct BlocksTip: Tip {
        var title: Text {
            Text("Add Focus Blocks")
        }
        
        var message: Text? {
            Text("Plus to add. Swipe right to duplicate. Swipe left to delete. Drag to rearange.")
            
        }
        
        var image: Image? {
            Image(systemName: "rectangle.stack.badge.plus")
        }
    }
    
    var completeTip = CompleteTip()
    struct CompleteTip: Tip {
        var title: Text {
            Text("Complete and Extend Blocks")
        }
        
        var message: Text? {
            Text("Swipe right to complete or extend a focus. Swipe left to reset.")
        }
        
        var image: Image? {
            Image(systemName: "checkmark.circle")
        }
    }
}

#Preview {
    NavigationStack {
        FlowView(model: FlowModel(mode: .flowStart))
    }
}
