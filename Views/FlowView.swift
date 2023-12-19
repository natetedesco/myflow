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
                Section(header: HStack {
                    Text("\(model.flow.blocks.count) Blocks")
                    Spacer()
                    Text(model.flow.blocks.count == 0 ? "No Blocks" : model.flow.totalFlowTimeFormatted())
                        .font(.footnote)
                        .fontWeight(.medium)
                }) {
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
                                .padding(.vertical, sizeClass == .regular ? 16 : -4)
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
                    .onMove(perform: move)
                }
                TipView(tip, arrowEdge: .top)
                    .listRowSeparator(.hidden, edges: [.bottom])
            }
            .listStyle(.plain)
            .navigationTitle(model.flow.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.showFlowRunning.toggle()
                    } label: {
                        Image(systemName: "chevron.up")
                            .font(.callout)
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
                            Image(systemName: "gobackward")
                                .font(.callout)
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
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            
                            Spacer()
                            
                            // Start
                            Button {
                                softHaptic()
                                model.Start()
                            } label: {
                                Text("Start Flow")
//                                    .fontWeight(.medium)
                            }
                            .disabled(model.flow.blocks.count == 0)
                            .padding(.trailing, -4)
                        } else {
                            
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
                                        .fontWeight(.medium)
                                }
                            }
                            .frame(width: 50, alignment: .leading)
                            
                            Spacer()
                            
                            if model.mode == .flowStart {
                                Button {
                                } label: {
                                    HStack {
                                        Text("Break")
                                            .font(.callout)
                                        Image(systemName: "chevron.down")
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, -2)
                                    }
                                    .foregroundStyle(.white.secondary)
                                    .padding(.leading, 8)
//                                    .padding(.vertical, 8)
//                                    .padding(.horizontal, 16)
//                                    .background(.regularMaterial)
//                                    .cornerRadius(20)
                                }
                                .foregroundStyle(.white.secondary)
                            }
                            
                            Spacer()
                            
                            Button {
                                model.Start()
                                softHaptic()
                            } label: {
                                Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                                    .padding(14)
                                    .background(Circle().foregroundStyle(.teal.quinary))
                            }
                            .frame(width: 50, alignment: .trailing)
                            
                            
                            
                            //                            Button {
                            //                                model.showFlowRunning.toggle()
                            //                            } label: {
                            //                                Image(systemName: "chevron.up")
                            //                                    .font(.title)
                            //                                    .foregroundStyle(.white.tertiary)
                            //                                    .fontWeight(.semibold)
                            //                                    .frame(maxWidth: .infinity)
                            //                                    .padding(.top, 8)
                            //                            }
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
                .presentationDetents([.fraction(6/10)])
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

#Preview {
    NavigationStack {
        FlowView(model: FlowModel())
    }
}


