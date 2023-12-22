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
                            } else if model.mode != .initial {
                                Button {
                                    model.extend()
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
                        
                        if model.mode != .breakRunning && model.mode != .breakPaused {
//                            Spacer()
                            // Start
                            Button {
                                softHaptic()
                                model.Start()
                            } label: {
                                Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                                    .font(.title3)
                                    .padding()
                                    .background(Circle().foregroundStyle(.teal.quinary))
                                    .padding(.leading, -8)
                            }
                            .disabled(model.flow.blocks.count == 0)
                        }
                        
                        Spacer()
                        
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
//                                .padding(.leading, -4)
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
                                    Section(header: Text("Select to Start")) {
                                        ForEach(values, id: \.self) { i in
                                            Button {
                                                model.breakTime = i * 60
                                                model.startBreak()
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
                                .padding(.leading, -16)
                            } else {
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
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Break")
                                                .font(.title3)
                                                .foregroundStyle(.white)
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 10))
                                                .fontWeight(.medium)
                                                .padding(.horizontal, -4)
                                                .foregroundStyle(.white)
                                        }
                                        Text(formatTime(seconds: model.breakTimeLeft))
                                            .font(.title2)
                                            .fontWeight(.light)
                                            .foregroundStyle(.white.secondary)
                                            .monospacedDigit()
                                    }
                                    .padding(.leading, -6)
                                }
                                
                                Spacer()
                                
                                Gauge(value: formatProgress(time: model.breakTime, timeLeft: model.breakTimeLeft), label: {Text("")})
                                    .gaugeStyle(.accessoryCircularCapacity)
                                    .tint(.gray)
                                    .scaleEffect(0.9)
                                    .padding(.trailing, -4)
                            }
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
        Text("Swipe left to complete early. If completed, swipe right to extend.")
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
