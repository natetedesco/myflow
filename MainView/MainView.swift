
//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct MainView: View {
    @State var model: FlowModel
    @AppStorage("ProAccess") var proAccess: Bool = false
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @State var renamedFlow = ""
    @State var showFlow = false
    @State var showCreateFlow = false
    @State var showRenameFlow = false
    @State var showDeleteAlert = false
    
    var spacing: CGFloat {
        if sizeClass == .regular {
            return 32
        }
        return 16
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // No Flows
                if model.flowList.count == 0 {
                    Spacer()
                    
                    Text("No Flows")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Button {
                        showCreateFlow.toggle()
                    } label : {
                        Text("Create Your Flow")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .padding(18)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.7)]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ))
                    .cornerRadius(20)
                    Spacer()
                } else {
                    
                    // Flows
                    ScrollView {
                        
                        // Header
                        if  model.flowList.count != 0 {
                            Text("Saved")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .leading()
                                .padding(.leading)
                                .padding(.top)
                        }
                        
                        // Flows
                        LazyVGrid(columns: [GridItem(spacing: spacing), GridItem(spacing: spacing)], spacing: spacing) {
                            ForEach($model.flowList) { $flow in
                                ZStack {
                                    Button {
                                        model.flow = flow
                                        lightHaptic()
                                        showFlow.toggle()
                                    } label: {
                                        VStack(alignment: .leading) {
                                            
                                            // Flow Title
                                            Text(flow.title)
                                                .foregroundStyle(.ultraThickMaterial)
                                                .environment(\.colorScheme, .light)
                                                .font(sizeClass == .regular ? .title : .title3)
                                                .fontWeight(.semibold)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                        }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                            .padding()
                                            .frame(height: sizeClass == .regular ? 224 : 116)
                                            .background(LinearGradient(
                                                gradient: Gradient(colors: [.teal.opacity(0.8), .teal.opacity(0.6)]),
                                                startPoint: .bottomLeading,
                                                endPoint: .topTrailing
                                            ))
                                            .cornerRadius(24)
                                    }
                                    .fullScreenCover(isPresented: $showFlow) {
                                        FlowView(model: model)
                                    }
                                    
                                    // Menu
                                    Menu {
                                        
                                        // Rename
                                        Button {
                                            model.flow = flow
                                            showRenameFlow.toggle()
                                        } label: {
                                            Label("Rename", systemImage: "pencil")
                                        }
                                        
                                        // Duplicate
                                        Button {
                                            if proAccess {
                                                model.duplicateFlow(flow: flow)
                                            } else {
                                                model.showLargePayWall.toggle()
                                            }
                                        } label: {
                                            Label("Duplicate", systemImage: "plus.square.on.square")
                                        }
                                        Divider()
                                        
                                        // Delete
                                        Button(role: .destructive) {
                                            model.deleteFlow(id: flow.id)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    } label: {
                                        
                                        // Menu Label
                                        Image(systemName: "ellipsis")
                                            .font(.callout)
                                            .foregroundStyle(.teal)
                                            .padding(12)
                                            .background(Circle().foregroundStyle(.bar))
                                    }
                                    .padding()
                                    .padding(.trailing, -6)
                                    .simultaneousGesture(TapGesture().onEnded{
                                        lightHaptic()
                                    })
                                    .shadow(color: .black.opacity(0.1), radius: 8)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    
                                    // Rename Flow Alert
                                    .alert("Rename Flow", isPresented: $showRenameFlow) { // Create Flow Alert
                                        TextField("Flow Title", text: $renamedFlow)
                                        Button("Rename", action: {
                                            if !renamedFlow.isEmpty {
                                                model.flow.title = renamedFlow
                                                renamedFlow = ""
                                                model.saveFlow()
                                            }
                                        })
                                        Button("Cancel", role: .cancel, action: {showRenameFlow = false})
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .animation(.default, value: model.flowList)
                    }
                    .animation(.default, value: model.flowList)
                }
            }
            .navigationTitle("Flows")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if  model.flowList.count != 0 {
                        Button {
                            if model.flowList.count >= 1 && !proAccess {
                                model.showLargePayWall.toggle()
                            } else {
                                showCreateFlow = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.medium)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        if !proAccess {
                            Button {
                                model.showLargePayWall.toggle()
                            } label: {
                                Text("Try Pro")
                                    .font(.footnote)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.white)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.7)]),
                                        startPoint: .bottomLeading,
                                        endPoint: .topTrailing
                                    ))                                    .cornerRadius(232)
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateFlow) {
            CreateFlowView(model: model, showFlow: $showFlow)
                .sheetMaterial()
        }
    }
}

#Preview {
    MainView(model: FlowModel(flowList: [Flow(title: "Flow"), Flow(title: "Morning Routine")]))
}

#Preview {
    MainView(model: FlowModel(flowList: []))
}
