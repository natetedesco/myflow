
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
                                                model.showPayWall(large: true)
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
                        
                        
//                        ForEach($model.flowList) { $flow in
//                            ZStack {
//                                Button {
//                                    model.flow = flow
//                                    lightHaptic()
//                                    showFlow.toggle()
//                                    
//                                } label: {
//                                    ZStack {
//                                        ZStack {
//                                            Circle()
//                                                .foregroundStyle(.teal)
//                                                .blur(radius: 140)
//                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                                                .padding(-32)
//                                                .padding(.leading, -224)
//                                                .padding(.bottom, -256)
//                                            
//                                            Circle()
//                                                .foregroundStyle(.teal)
//                                                .blur(radius: 140)
//                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                                                .padding(-32)
//                                                .padding(.leading, -224)
//                                                .padding(.bottom, -256)
//                                                .opacity(0.3)
//
//                                        }
//                                        
//                                        VStack(alignment: .leading) {
//                                            Text(flow.title)
//                                                .font(.title2)
//                                                .fontWeight(.semibold)
//                                                .foregroundStyle(.white.opacity(0.9))
//
//                                            Text(flow.totalFlowTimeFormattedLong())
//                                                .font(.callout)
//                                                .fontWeight(.semibold)
//                                                .foregroundStyle(.thinMaterial)
//                                        }
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                                    }
//                                }
//                                .fullScreenCover(isPresented: $showFlow) {
//                                    FlowView(model: model)
////                                        .presentationBackground(.regularMaterial)
//                                }
//                                
//                                Menu {
//                                    
//                                    // Rename
//                                    Button {
//                                        model.flow = flow
//                                        showRenameFlow.toggle()
//                                    } label: {
//                                        Label("Rename", systemImage: "pencil")
//                                    }
//                                    
//                                    // Duplicate
//                                    Button {
//                                        if proAccess {
//                                            model.duplicateFlow(flow: flow)
//                                        } else {
//                                            model.showPayWall(large: true)
//                                        }
//                                    } label: {
//                                        Label("Duplicate", systemImage: "plus.square.on.square")
//                                    }
//                                    Divider()
//                                    
//                                    // Delete
//                                    Button(role: .destructive) {
//                                        model.deleteFlow(id: flow.id)
//                                    } label: {
//                                        Label("Delete", systemImage: "trash")
//                                    }
//                                } label: {
//                                    Image(systemName: "ellipsis")
//                                        .foregroundStyle(.teal)
//                                        .padding(14)
//                                        .background(Circle().foregroundStyle(.black.opacity(0.3)))
//                                        .padding(.trailing, -8)
//                                }
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                                .shadow(color: .black.opacity(0.2), radius: 8)
//                                
//                                // Rename Flow Alert
//                                .alert("Rename Flow", isPresented: $showRenameFlow) { // Create Flow Alert
//                                    TextField("Flow Title", text: $renamedFlow)
//                                    Button("Rename", action: {
//                                        if !renamedFlow.isEmpty {
//                                            model.flow.title = renamedFlow
//                                            renamedFlow = ""
//                                            model.saveFlow()
//                                        }
//                                    })
//                                    Button("Cancel", role: .cancel, action: {showRenameFlow = false})
//                                }
//                            }
//                            .padding(.vertical)
//                            .padding(.horizontal, 20)
//                            .background(.ultraThickMaterial)
//                            .cornerRadius(30)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 120)
//                            .padding(.vertical, 3)
//                            .padding(.horizontal)
//                        }
                        
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
                                model.showPayWall(large: true)
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
                        if model.settings.developerSettings {
                            Button {
                                model.settings.showOnboarding = true
                                fatalError()
                            } label: {
                                Image(systemName: "menucard")
                            }
                        }
                        
                        if !proAccess {
                            Button {
                                model.showPayWall(large: true)
                            } label: {
                                Text("Pro")
                                    .fontWeight(.medium)
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
