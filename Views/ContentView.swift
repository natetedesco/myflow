
//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @State var model = FlowModel()
    @State var showFlow = false
    
    var body: some View {
        
        ZStack {
            NavigationStack {
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
                            
                            
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                
                                
                                ForEach(0..<model.flowList.count, id: \.self) { i in
                                    if i < model.flowList.count {
                                        let flow = model.flowList[i]
                                        
                                        Button {
                                            
                                            showFlow.toggle()
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
                                                    //                                                            .rotationEffect(.degrees(90))
                                                }
                                                .padding(.trailing, -4)
                                                //                                                    .padding(.leading, -8)
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
                                                gradient: Gradient(colors: [.myColor.opacity(0.8), .myColor.opacity(0.6)]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ))
                                            .background(.bar)
                                            .cornerRadius(24)
                                            .shadow(color: Color.myColor.opacity(0.3), radius: 3)
                                            
                                        }
                                        .simultaneousGesture(TapGesture().onEnded{
                                            model.selection = i
                                            model.selectedIndex = i
                                        })
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
                    
                    // Top Bar
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            
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
                                    //                                        .font(.title3)
                                        .fontWeight(.medium)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea(.keyboard)
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
            
            .fullScreenCover(isPresented: $showFlow) {
                FlowView(model: model)
                    .accentColor(.teal)
            }
            
            
            .sheet(isPresented: $showAppBlocker) {
                DistractionBlocker(model: model)
                    .presentationCornerRadius(32)
                    .presentationBackground(.regularMaterial)
                    .presentationDragIndicator(.hidden)
                    .accentColor(.teal)
            }
            .sheet(isPresented: $showCreateFlow) {
                CreateFlowView(model: model)
                    .accentColor(.teal)
                    .presentationBackground(.regularMaterial)
                    .presentationCornerRadius(32)
            }
            
            
            .sheet(isPresented: $model.showFlowCompleted) {
                ShowFlowCompletedView(model: model)
                    .presentationBackground(.regularMaterial)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}




