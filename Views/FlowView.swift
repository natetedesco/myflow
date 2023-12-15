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
                Section(header:
                            HStack {
                    Text("\(model.flow.blocks.count) Blocks")
                    Spacer()
                    Text(model.flow.blocks.count == 0 ? "No Blocks" : model.flow.totalFlowTimeFormatted())
                        .font(.footnote)
                        .fontWeight(.medium)
                }
                ) {
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
                                .padding(.vertical, sizeClass == .regular ? 16 : -6)
                            
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
                            Text("Focus")
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    if model.mode == .initial {
                        // Back
                        Button {
                            model.saveFlow()
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                    }
                    else {
                        // Reset
                        Button {
                            model.Reset()
                        } label: {
                            Image(systemName: "gobackward")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        // Start
                        Button {
                            softHaptic()
                            model.Start()
                        } label: {
                            Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                                .font(.title3)
                                .padding()
                                .background(Circle().foregroundStyle(.teal.quinary))
                                .padding(.leading, -10)
                        }
                        .disabled(model.flow.blocks.count == 0)
                        Spacer()
                        
                        if model.mode == .initial && model.mode != .flowStart {
                            // Plus
                            Button {
                                lightHaptic()
                                model.addBlock()
                                model.showBlock.toggle()
                                newBlock.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
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
                                        Image(systemName: model.mode == .flowStart ? "goforward.plus" :"checkmark.circle")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    Text(model.mode == .flowStart ? "Extend" : "Complete")
                                        .font(.callout)
                                }
                            }
                            .padding(.leading, -6)
                        }
                    }
                    .padding(.top, 12)
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(model.mode == .flowRunning ? true : false)
            //            .navigationBarTitleDisplayMode(model.flow.blocks.count > 8 ? .inline : .large)
        }
        .sheet(isPresented: $model.showBlock) {
            BlockSheetView(model: model, newBlock: $newBlock)
                .presentationCornerRadius(32)
                .presentationDetents([.fraction(1/3)])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .presentationBackground(.regularMaterial)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        .fullScreenCover(isPresented: $model.showFlowRunning) {
            FlowRunning(model: model)
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
