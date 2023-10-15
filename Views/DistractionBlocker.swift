//
//  DistractionBlocker.swift
//  MyFlow
//
//  Created by Nate Tedesco on 8/29/23.
//

import SwiftUI
import FamilyControls

struct DistractionBlocker: View {
    let center = AuthorizationCenter.shared
    @AppStorage("ScreenTimeAuthorized") var isAuthorized: Bool = false
    
    @State var isPresented = false
    
    @Bindable var model: FlowModel
    @StateObject var settings = Settings()
    
    @State var showPaywall = false
    @State var detent = PresentationDetent.large
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    var body: some View {
            
            NavigationView {
                VStack(spacing: 16) {
                    
                    if isAuthorized {
                        VStack {
                            if !proAccess {
                                Button {
                                    showPaywall.toggle()
                                } label: {
                                    Text("Enable")
                                        .foregroundColor(.myColor)
                                        .fontWeight(.medium)
                                        .padding(.vertical, 2) // lil extra
                                }
                            } else {
                                Toggle(isOn: settings.$blockDistractions) {
                                    Text("Block Apps")
                                        .fontWeight(.medium)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color.myColor))
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .cornerRadius(24)
                    }
                    
                    VStack {
                        if isAuthorized {
                            Button {
                                if proAccess {
                                    isPresented = true
                                }
                            } label: {
                                HStack {
                                    Text("Blocked Apps")
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                    Spacer()
                                    if model.activitySelection.applicationTokens.isEmpty && model.activitySelection.categoryTokens.isEmpty &&
                                        model.activitySelection.webDomainTokens.isEmpty {
                                        Text("None")
                                            .foregroundColor(.gray)
                                    } else {
                                        if !proAccess {
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(.gray)
                                        } else {
                                            Text(Image(systemName: "chevron.right"))
                                                .foregroundColor(.gray)
                                                .fontWeight(.semibold)
                                        }
                                        
                                    }
                                }
                            }
                            .familyActivityPicker(isPresented: $isPresented, selection: $model.activitySelection)
                        } else {
                            Button {
                                Task {
                                    do {
                                        try await center.requestAuthorization(for: .individual)
                                        isAuthorized = true
                                    } catch {
                                        print("error")
                                    }
                                }
                            } label: {
                                Text("Authorize")
                                    .foregroundColor(.myColor)
                            }
                        }
                        
                        // App Icons
                        if !model.activitySelection.applicationTokens.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(Array(model.activitySelection.applicationTokens), id: \.self) { applicationToken in
                                        Label(applicationToken)
                                            .labelStyle(.iconOnly)
                                            .scaleEffect(1.5)
                                        
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .cornerRadius(24)
                    
                    Text(isAuthorized ? "You wont have access to these apps during flow": "MyFlow needs to access Screen Time")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    
                    //                Spacer()
                    
                }
                .padding()
                .navigationTitle("App Blocker")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showPaywall) {
                    PayWall(detent: $detent)
                        .presentationCornerRadius(40)
                        .presentationBackground(.bar)
                        .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                        .interactiveDismissDisabled(detent == .large)
                        .presentationDragIndicator(detent == .large ? .visible : .hidden)
                }
            }
    }
}

