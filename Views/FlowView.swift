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
    var tip = BlocksTip()
    var completeTip = CompleteTip()

    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var selectedBreakTime = 5
    let values = [30, 20, 15, 10, 5, 2, 1]
    @State var newBlock = false
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: HStack {
                    Text("\(model.flow.blocks.count) Blocks")
                    Spacer()
                    Text(model.flow.blocks.count == 0 ? "No Blocks" : model.flow.totalFlowTimeFormatted())
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
                            }
                        } label: {
                            BlockView(model: model, block: $block)
                                .padding(.vertical, sizeClass == .regular ? 16 : -2)
                        }
                        .swipeActions(edge: .leading) {
                            if model.mode == .initial {
                                Button {
                                    model.duplicateBlock(block: block)
                                } label: {
                                    Text("Duplicate")
                                }
                                .tint(.teal)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            if model.mode == .flowRunning && currentBlock(block: block) {
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
                    }
                    .onDelete(perform: model.mode == .initial ? delete : nil)
                    .onMove(perform: move)
                }
                TipView(tip, arrowEdge: .top)
                    .listRowSeparator(.hidden, edges: [.bottom])
            }
            .listStyle(.plain)
            .navigationTitle(model.flow.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {}
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    if model.mode == .initial {
                        // Back
                        Button {
                            model.saveFlow()
                            dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                    else {
                        // Reset
                        Button {
                            model.Reset()
                        } label: {
                            Text("Reset")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        
                        // Initial
                        if model.mode == .initial {
                            
                            // Plus
                            Button {
                                lightHaptic()
                                model.addBlock()
                                model.showBlock.toggle()
                                newBlock.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                .padding(.leading, -8)
                            }
                            
                            // Focus View Toggle
                        } else {
                            if model.mode == .flowRunning || model.mode == .flowPaused {
                                Button {
                                    model.showFlowRunning.toggle()
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .font(.title3)
                                        .foregroundStyle(.white.tertiary)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                }
                            } else if model.mode == .flowStart {
                                
                                // Break
                                Menu {
                                    Section(header: Text("Select to Start Break")) {
                                        ForEach(values, id: \.self) { i in
                                            Button {
                                                selectedBreakTime = i
                                                model.startBreak()
                                            } label: {
                                                Text("\(i) min")
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text("Break")
                                            .font(.system(size: 14))
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 10))
                                            .fontWeight(.medium)
                                            .padding(.horizontal, -4)
                                    }
                                    .foregroundStyle(.white.secondary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(.regularMaterial)
                                    .cornerRadius(20)
                                    .padding(.leading, -8)
                                    .padding(.top, 4)
                                }
                                .foregroundStyle(.white.secondary)
                            } else {
                                Menu {
                                    Button {
                                        
                                    } label: {
                                        Text("End Break")
                                    }
                                } label: {
                                    HStack {
                                        Text("Break 20:00")
                                            .font(.title3)
//                                        Image(systemName: "chevron.down")
//                                            .font(.system(size: 10))
//                                            .fontWeight(.medium)
//                                            .padding(.horizontal, -4)
//                                            .foregroundStyle(.white.secondary)
                                    }
                                    .foregroundStyle(.white.secondary)
                                }
                                
                                Spacer()
                                
                                Button {
                                    softHaptic()
                                    model.Start()
                                } label: {
                                    Image(systemName: "pause.fill")
                                        .padding()
                                        .foregroundStyle(.white.secondary)
                                        .background(Circle().foregroundStyle(.white.quinary))
                                        .padding(.trailing, -8)
                                }

                                
                            }
                        }
                        
                        
                        if model.mode != .breakRunning {
                            Spacer()
                            // Start
                            Button {
                                softHaptic()
                                model.Start()
                            } label: {
                                Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                                    .padding()
                                    .background(Circle().foregroundStyle(.teal.quinary))
                                    .padding(.trailing, -8)
                            }
                            .disabled(model.flow.blocks.count == 0)
                        }
                    }
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
        .fullScreenCover(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model)
        }
        .sheet(isPresented: $model.showFlowCompleted) {
            FlowCompletedView(model: model)
                .sheetMaterial()
                .presentationDetents([.fraction(4/10)])
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
    
}

struct BlocksTip: Tip {
    var title: Text {
        Text("Focus Blocks")
    }
    
    var message: Text? {
        Text("Drag to reorder. Swipe right to duplicate. Swipe left to delete.")
    }
    
    var image: Image? {
        Image(systemName: "rectangle.stack")
    }
}

struct CompleteTip: Tip {
    var title: Text {
        Text("Complete & Extend Blocks")
    }
    
    var message: Text? {
        Text("Swipe right to complete early. If completed, swipe right to extend.")
    }
    
    var image: Image? {
        Image(systemName: "checkmark.circle")
    }
}

#Preview {
    NavigationStack {
        FlowView(model: FlowModel(mode: .flowStart))
    }
}
