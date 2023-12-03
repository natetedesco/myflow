//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct FlowView: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            List{
                Section(header: Text("Total: " + model.flow.totalFlowTimeFormatted())) {
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
                                Label("Duplicate", systemImage: "plus.square.on.square")
                            }
                            .tint(.teal)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .listStyle(.plain)
            .navigationTitle(model.flowList[model.selection].title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    if model.mode != .initial {
                        Button {
                            model.showFlowRunning.toggle()
                        } label: {
                            Gauge(value: formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft)) {
                            } currentValueLabel: {
                                Text(formatTime(seconds: model.flowTimeLeft))
                                    .foregroundStyle(.white)
                            }
                            .gaugeStyle(.accessoryCircularCapacity)
                            .scaleEffect(0.65)
                            .tint(.accentColor)
                        }
                        .padding(.bottom, -4)
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
                            dismiss()
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
                            } label: {
                                Image(systemName: "plus")
                                    .fontWeight(.semibold)
                                    .font(.title2)
                            }
                        } else {
                            Button {
                                model.Skip()
                                softHaptic()
                            } label: {
                                Text("Complete")
                                    .foregroundColor(.myColor)
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
        }
    }
    
    func delete(at offsets: IndexSet) {
        model.flow.blocks.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.flow.blocks.move(fromOffsets: source, toOffset: destination)
    }
}


