
//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct MainView: View {
    @State var model: FlowModel
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @State var showPaywall = false
    @State var detent = PresentationDetent.large
    
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
                if model.flowList.count == 0 {
                    VStack(spacing: 16) {
                        Spacer()
                        Text("No Flows")
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        Button {
                            showCreateFlow.toggle()
                        } label : {
                            Text("Create Your Flow")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        Text("All")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .leading()
                            .padding(.leading)
                            .padding(.top, 26)
                        
                        LazyVGrid(columns: [GridItem(spacing: spacing), GridItem(spacing: spacing)], spacing: spacing) {
                            ForEach($model.flowList) { $flow in
                                
                                ZStack {
                                    Button {
                                        model.flow = flow
                                        showFlow.toggle()
                                    } label: {
                                        Text(flow.title)
                                            .foregroundStyle(.white)
                                            .font(sizeClass == .regular ? .title : .title3)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                                            .padding()
                                            .frame(height: sizeClass == .regular ? 224 : 112)
                                            .background(LinearGradient(
                                                gradient: Gradient(colors: [.teal.opacity(0.8), .teal.opacity(0.6)]),
                                                startPoint: .bottomLeading,
                                                endPoint: .topTrailing
                                            ))
                                            .cornerRadius(24)
                                            .shadow(color: Color.teal.opacity(0.3), radius: 3)
                                    }
                                    .fullScreenCover(isPresented: $showFlow) {
                                        FlowView(model: model)
                                    }
                                    
                                    // Menu
                                    Menu {
                                        Button {
                                            model.flow = flow
                                            showRenameFlow.toggle()
                                        } label: {
                                            Label("Rename", systemImage: "pencil")
                                        }
                                        Button {
                                            if proAccess {
                                                model.duplicateFlow(flow: flow)
                                            } else {
                                                showPaywall.toggle()
                                            }
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
                                            .font(.callout)
                                            .foregroundStyle(.teal)
                                            .padding(12)
                                            .background(Circle().foregroundStyle(.regularMaterial))
                                    }
                                    .padding()
                                    .padding(.trailing, -4)
                                    .simultaneousGesture(TapGesture().onEnded{
                                        lightHaptic()
                                    })
                                    .shadow(color: .black.opacity(0.1), radius: 8)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    
                                    // Rename Flow
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
                                .fontWeight(.medium)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateFlow) {
            CreateFlowView(model: model, showFlow: $showFlow)
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(32)
        }
        .sheet(isPresented: $showPaywall) {
            PayWall(detent: $detent)
                .presentationCornerRadius(32)
                .presentationBackground(.regularMaterial)
                .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                .interactiveDismissDisabled(detent == .large)
                .presentationDragIndicator(detent != .large ? .visible : .hidden)
        }
    }
}

private func shouldUseLargeHeight() -> Bool {
    let horizontalSizeClass = UITraitCollection(horizontalSizeClass: UIScreen.main.bounds.width > 500 ? .regular : .compact)
    return horizontalSizeClass.containsTraits(in: UITraitCollection(horizontalSizeClass: .regular))
}

#Preview {
    MainView(model: FlowModel())
}
