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
    
    
    @State var newBlock = false
    
    var body: some View {
        
        NavigationStack {
            
            List{
                Section(header: Text(model.flow.totalFlowTimeFormatted())) {
                    ForEach($model.flow.blocks) { $block in
                        Button {
                            if let selectedIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                                model.selectedIndex = selectedIndex
                                model.showBlock.toggle()
                            }
                            
                        } label: {
                            BlockView(model: model, block: $block)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                model.duplicateBlock(block: block)
                            } label: {
                                Text("Duplicate")
//                                Label("Duplicate", systemImage: "plus.square.on.square")
                            }
                            .tint(.teal)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
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
                    }
                }
                
                ToolbarItemGroup(placement: .topBarLeading) {
                    if model.mode == .initial {
                        Button {
                            model.saveFlow()
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .fontWeight(.semibold)
                                    .padding(.trailing, -4)
                                Text("Flows")
                            }
                            .padding(.leading, -12)
                        }
                    } else {
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
                            
                            Button {
                                lightHaptic()
                                model.addBlock()
                                model.showBlock.toggle()
                                model.newBlock.toggle()
                            } label: {
                                Image(systemName: "plus")
                                    .fontWeight(.semibold)
                                    .font(.title2)
                            }
                            .padding(.leading, -6)
                            
                        } else {
                            Button {
                                if model.mode == .flowStart {
                                    model.continueFlow()
                                } else {
                                    model.Skip()
                                }
                                softHaptic()
                            } label: {
                                HStack {
                                    Image(systemName: model.mode == .flowStart ? "goforward.plus" :"goforward")
                                    Text(model.mode == .flowStart ? "Extend" : "Complete")
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
                    }
                    .padding(.top, 4)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(model.mode == .flowRunning ? true : false)
        }
        .sheet(isPresented: $model.showBlock) {
            BlockSheetView(model: model)
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
                .presentationDetents([.fraction(6/10)])
                .presentationDragIndicator(.hidden)
        }
    }
    
    func delete(at offsets: IndexSet) {
        model.flow.blocks.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.flow.blocks.move(fromOffsets: source, toOffset: destination)
    }
}

struct BlocksTip: Tip {
    var title: Text {
        Text("Focus Blocks")
    }
    
    var message: Text? {
        Text("Tap to edit. Drag to rearrange. Swipe left to delete. Swipe right to duplicate.")
    }
    
    var image: Image? {
        Image(systemName: "pencil")
    }
}
