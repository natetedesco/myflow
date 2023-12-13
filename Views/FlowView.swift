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
    @Environment(\.horizontalSizeClass) private var sizeClass

    @State var newBlock = false
    
    var body: some View {
        NavigationStack {
            List{
                Section(header: Text(model.flow.blocks.count == 0 ? "No Blocks" : model.flow.totalFlowTimeFormatted())) {
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
                                .padding(.vertical, sizeClass == .regular ? 16 : 0)

                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                model.duplicateBlock(block: block)
                            } label: {
                                Text("Duplicate")
                            }
                            .tint(.teal)
                        }
                    }
                    .onDelete(perform: model.mode == .initial ? delete : nil)
                    .onMove(perform: model.mode == .initial ? move : nil)
                }
                TipView(tip, arrowEdge: .top)
                    .listRowSeparator(.hidden, edges: [.bottom])
            }
            .listStyle(.plain)
            .navigationTitle(model.flow.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if model.mode != .initial {
                        Button {
                            model.showFlowRunning.toggle()
                        } label: {
                            Image(systemName: "timer")
                        }
                        .padding(.trailing, 12)
                    }
                }
                
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
                        if model.mode == .initial && model.mode != .flowStart {
                            
                            // Plus
                            Button {
                                lightHaptic()
                                model.addBlock()
                                model.showBlock.toggle()
                                newBlock.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                        .fontWeight(.semibold)
                                        .font(.title3)
                                    Text("Block")
                                        .fontWeight(.semibold)
                                }
                            }
                            .padding(.leading, -6)
                            
                        } else {
                            
                            // Continue / Extend
                            Button {
                                if model.mode == .flowStart {
                                    model.extend()
                                } else if model.flowExtended {
                                    model.completeExtend()
                                } else {
                                    model.Complete()
                                }
                                softHaptic()
                            } label: {
                                HStack {
                                    if !model.flowExtended{
                                        Image(systemName: model.mode == .flowStart ? "goforward.plus" :"checkmark.circle")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    Text(model.mode == .flowStart ? "Extend" : "Complete")
                                        .fontWeight(.medium)
                                }
                                .font(.callout)
                            }
                            .padding(.leading, -6)
                        }
                        
                        Spacer()
                        
                        // Start
                        Button {
                            softHaptic()
                            model.Start()
                        } label: {
                            Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                                .font(.title3)
                                .padding()
                                .background(Circle().foregroundStyle(.teal.quinary))
                                .padding(.trailing, -6)
                        }
                        .disabled(model.flow.blocks.count == 0)
                    }
                    .padding(.top, 8)
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(model.mode == .flowRunning ? true : false)
        }
        .sheet(isPresented: $model.showBlock) {
            BlockSheetView(model: model, newBlock: $newBlock)
                .accentColor(.teal)
                .presentationCornerRadius(32)
                .presentationDetents([.fraction(1/3)])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationBackground(.regularMaterial)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        .fullScreenCover(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model)
                .accentColor(.teal)
        }
        .sheet(isPresented: $model.showFlowCompleted) {
            ShowFlowCompletedView(model: model)
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(32)
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
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
