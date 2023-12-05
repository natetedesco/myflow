
//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct MainView: View {
    @State var model: FlowModel
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                VStack {
                    if model.flowList.count == 0 {
                        VStack(spacing: 16) {
                            Spacer()
                            Text("No Flows")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Button {
                                showCreateFlow.toggle()
                            } label : {
                                Text("Create Your Flow")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                            }
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(8)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            Text("All")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .fontWeight(.semibold)
                                .leading()
                                .padding(.leading)
                                .padding(.top)
                            
                            LazyVGrid(columns: [GridItem(spacing: 16), GridItem(spacing: 16)], spacing: 16) {
                                ForEach(0..<model.flowList.count, id: \.self) { i in
                                    if i < model.flowList.count {
                                        let flow = model.flowList[i]
                                        
                                        Button {
                                            model.flow = model.flowList[i]
                                            model.showFlow.toggle()
                                        } label: {
                                            ZStack {
                                                Text(flow.title)
                                                    .foregroundStyle(.white)
                                                    .font(.title3)
                                                    .fontWeight(.medium)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                                
                                                Spacer()
                                                
                                                Menu {
                                                    Button {
                                                        renameIndex = i
                                                        renameFlow.toggle()
                                                    } label: {
                                                        Label("Rename", systemImage: "pencil")
                                                    }
                                                    Button {
                                                        model.duplicateFlow(flow: flow)
                                                    } label: {
                                                        Label("Duplicate", systemImage: "plus.square.on.square")
                                                    }
                                                    Button(role: .destructive) {
                                                        model.deleteFlow(id: flow.id)
                                                    } label: {
                                                        Label("Delete", systemImage: "trash")
                                                    }
                                                } label: {
                                                    Image(systemName: "ellipsis")
                                                        .font(.callout)
                                                        .foregroundStyle(.teal)
                                                        .padding(12)
                                                        .background(Circle().foregroundStyle(.regularMaterial))
                                                }
                                                .padding(.trailing, -4)
                                                .simultaneousGesture(TapGesture().onEnded{
                                                    lightHaptic()
                                                })
                                                .shadow(color: .black.opacity(0.1), radius: 8)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                                
                                                
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 112)
                                            
                                            .background(LinearGradient(
                                                gradient: Gradient(colors: [.teal.opacity(0.8), .teal.opacity(0.6)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ))
                                            .background(.bar)
                                            .cornerRadius(24)
                                            .shadow(color: Color.teal.opacity(0.3), radius: 3)
                                            
                                        }
//                                        .simultaneousGesture(TapGesture().onEnded{
//                                            model.selectedIndex = i
//                                        })
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .animation(.default, value: model.flowList)
                    }
                }
                
                .navigationTitle("Flows")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        
                        if  model.flowList.count != 0 {
                            Button {
                                if model.flowList.count >= 2 && !proAccess {
                                    detent = .large
                                    showPaywall.toggle()
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
                        
                        if !proAccess {
                            Button {
                                showPaywall.toggle()
                            } label: {
                                Text("Pro")
                            }
                        }
                    }
                }
//                .ignoresSafeArea(.keyboard)
            }
            
            // Rename Flow
            .alert("Rename Flow", isPresented: $renameFlow) { // Create Flow Alert
                TextField("Flow Title", text: $renamedFlow)
                Button("Rename", action: {
                    if !renamedFlow.isEmpty {
                        model.renameFlow(index: renameIndex, newTitle: renamedFlow)
                        renamedFlow = ""
                    }
                })
                Button("Cancel", role: .cancel, action: {})
            }
            
            .fullScreenCover(isPresented: $model.showFlow) {
                FlowView(model: model)
                    .accentColor(.teal)
            }
            .sheet(isPresented: $showCreateFlow) {
                CreateFlowView(model: model)
                    .accentColor(.teal)
                    .presentationBackground(.regularMaterial)
                    .presentationCornerRadius(32)
            }
            .sheet(isPresented: $showPaywall) {
                PayWall(detent: $detent)
                    .presentationCornerRadius(32)
                    .presentationBackground(.bar)
                    .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                    .interactiveDismissDisabled(detent == .large)
                    .presentationDragIndicator(detent != .large ? .visible : .hidden)
            }
            
            // Onboarding
        }
    }
    
    @StateObject var settings = Settings()
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @State var showBlur = true
    
    @State var showStatistics = false
    @State var showSettings = false
    @State var showAppBlocker = false
    
    @State var showPaywall = false
    @State var detent = PresentationDetent.large
    
    @State var showCreateFlow = false
    
    @State var newFlowTitle = ""
    @State var renameIndex = 0
    @State var renameFlow = false
    
    @State var renamedFlow = ""
    @State var showDeleteAlert = false
}

