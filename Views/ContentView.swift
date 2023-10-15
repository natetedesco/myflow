//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var model = FlowModel()
    @StateObject var settings = Settings()
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @State var showBlur = true
    
    @State var showPaywall = false
    @State var detent = PresentationDetent.large
    
    @State var showStatistics = false
    @State var showSettings = false
    @State var showAppBlocker = false
    @State var createFlow = false
    
    @State var showCreateFlow = false
    @State var newFlowTitle = ""
    @State var renameIndex = 0
    @State var renameFlow = false
    @State var renamedFlow = ""
    @State var showDeleteAlert = false
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                ZStack {
                    
                    VStack {
                        
                        if model.flowList.count == 0 {
                            VStack(spacing: 16) {
                                Spacer()
                                Image(systemName: "camera.filters")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.myColor)
                                Text("No Flows")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Button {
                                    showCreateFlow.toggle()
                                } label : {
                                    Text("Create Your Flow")
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                }
                                .padding()
                                //                            .padding(.horizontal)
                                .background(Color.myColor)
                                .cornerRadius(8)
                                Spacer()
                            }
                        } else {
                            
                            ScrollView {
                                Text("All")
                                    .font(.headline)
                                    .leading()
                                    .padding(.leading)
                                
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                                    
                                    ForEach(0..<model.flowList.count, id: \.self) { i in
                                        if i < model.flowList.count {
                                            let flow = model.flowList[i]
                                            
                                            ZStack {
                                                Button {
                                                    model.showFlow = true
                                                } label: {
                                                    ZStack {
                                                        Rectangle()
                                                            .fill(
                                                                LinearGradient(
                                                                    gradient: Gradient(colors: [.myColor.opacity(0.8), .myColor.opacity(0.6)]),
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                )
                                                            )
                                                            .background(.ultraThinMaterial)
                                                            .cornerRadius(24)
                                                            .padding(-16)
                                                        
                                                        
                                                        VStack(alignment: .leading) {
                                                            Text(flow.title)
                                                                .foregroundStyle(.white)
                                                                .font(.title2)
                                                                .fontWeight(.semibold)
                                                                .multilineTextAlignment(.leading)
                                                            Text(flow.totalFlowTimeFormatted())
                                                                .font(.footnote)
                                                                .foregroundStyle(.white.secondary)
                                                                .fontWeight(.semibold)
                                                        }
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                                        
                                                        // Menu
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
                                                            Divider()
                                                            Button(role: .destructive) {
                                                                model.deleteFlow(id: flow.id)
                                                            } label: {
                                                                Label("Delete", systemImage: "trash")
                                                            }
                                                        } label: {
                                                            Image(systemName: "ellipsis")
                                                                .foregroundStyle(.white.secondary)
                                                                .padding(12)
                                                                .background(Circle().foregroundStyle(.ultraThinMaterial))
                                                                .padding(.trailing, -6)
                                                        }
                                                        .simultaneousGesture(TapGesture().onEnded{
                                                            lightHaptic()
                                                        })
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                                        .shadow(color: .black.opacity(0.1), radius: 8)
                                                    }
                                                }
                                                .simultaneousGesture(TapGesture().onEnded{
                                                    model.selection = i
                                                    model.selectedIndex = i
                                                })
                                                .padding()
                                                
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 112)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .animation(.default, value: model.flowList)
                        }
                    }
                }
                .navigationTitle("Flows")
                .toolbar {
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            
                            // Statistics
                            Button {
                                showStatistics = true
                                lightHaptic()
                            } label: {
                                Image(systemName: "bolt.fill")
                                    .font(.headline)
                                    .padding(12)
                                    .background(Circle().foregroundStyle(.ultraThinMaterial))
                            }
                            
                            Spacer()
                            
                            // Profile
                            Button {
                                showSettings = true
                                lightHaptic()
                            } label: {
                                Image(systemName: "person.fill")
                                    .padding(12)
                                    .background(Circle().foregroundStyle(.ultraThinMaterial))
                            }
                        }
                        //                    .padding(.top, 8)
                        
                    }
                    
                    // Top Bar
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button {
                                showAppBlocker.toggle()
                                lightHaptic()
                            } label: {
                                Image(systemName: settings.blockDistractions ? "shield.fill" : "shield")
                            }
                            
                            if  model.flowList.count != 0 {
                                Button {
                                    if model.flowList.count >= 1 && !proAccess {
                                        detent = .large
                                        showPaywall.toggle()
                                    } else {
                                        showCreateFlow = true
                                    }
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.title3)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
            }
            
            
            // Create Flow
            .alert("Create Flow", isPresented: $showCreateFlow) { // Create Flow Alert
                TextField("Flow Title", text: $newFlowTitle)
                Button("Create", action: {
                    if !newFlowTitle.isEmpty {
                        model.createFlow(title: newFlowTitle == "" ? "Flow" : newFlowTitle)
                        newFlowTitle = ""
                        model.selection = model.flowList.count - 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                            model.showFlow = true
                        }
                    }
                })
                Button("Cancel", role: .cancel, action: {})
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
            
            .accentColor(.myColor)
            .fullScreenCover(isPresented: $model.showFlow) {
                FlowView(model: model)
                    .presentationCornerRadius(40)
                    .presentationDetents([.large])
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDragIndicator(.visible)
                    .accentColor(.myColor)
            }
            
            .sheet(isPresented: $showStatistics) {
                StatsView()
                    .presentationBackground(.regularMaterial)
                    .presentationCornerRadius(40)
                    .presentationDetents([.large])
                    .presentationBackgroundInteraction(.enabled)
                    .presentationDragIndicator(.visible)
                
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(model: model)
                    .presentationBackground(.regularMaterial)
                    .presentationCornerRadius(40)
                    .presentationDragIndicator(.visible)
                
            }
            
            .sheet(isPresented: $showAppBlocker) {
                DistractionBlocker(model: model)
                    .presentationCornerRadius(40)
                    .presentationBackground(.regularMaterial)
                    .presentationDetents([.fraction(3/7)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $model.showFlowCompleted) {
                ZStack {
                    
                    VStack {
                        Circles(model: model, size: 160, width: 16.0, fill: true)
                            .padding(.top)
                        
                        Spacer()
                        
                        Text("Flow Completed")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        HStack {
                            Text("Total FlowTime: ")
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                                .fontWeight(.medium)
                            Text(formatHoursAndMinutes(time: model.totalFlowTime/60))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.myColor)
                        }
                        .padding(.bottom, 32)
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal)
                .presentationBackground(.bar)
                .presentationCornerRadius(40)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showPaywall) {
                PayWall(detent: $detent)
                    .presentationCornerRadius(40)
                    .presentationBackground(.bar)
                    .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                    .interactiveDismissDisabled(detent == .large)
                    .presentationDragIndicator(detent == .large ? .visible : .hidden)
            }
            
            ZStack {
                AnimatedBlur(opacity: showBlur ? 0.5 : 0.0)
                    .animation(.default.speed(2.0), value: showBlur)
                
                VStack {
                    
                    Spacer()
                    
                    Circles(model: model, size: 160, width: 16.0, fill: true)
                    
                    Spacer()
                    
                    Text("Experience Flow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(2)
                    Text("In a world of distractions, focus on what truly matters to you. We hope this app will help.")
                        .font(.callout)
//                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 64)
                        .multilineTextAlignment(.center)
                    
                    
                    Spacer()
                    
                    Button {
                        showBlur = false
                        detent = .fraction(6/10)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
                            showOnboarding = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            showPaywall = true
                        }
                    } label: {
                        Text("Let's Flow")
                    }
                    .fontWeight(.medium)
                    .foregroundStyle(Color.myColor)
                    .padding(.bottom)
                }
                .opacity(showOnboarding ? 1.0 : 0.0)
                .animation(.easeOut, value: showOnboarding)
                
            }
            .background(Color.black)
            .opacity(showOnboarding ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 2.0), value: showOnboarding)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
