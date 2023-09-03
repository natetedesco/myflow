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
    @ObservedObject var model: FlowModel
    @StateObject var settings = Settings()
    @State private var showingSheet = false
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "shield")
                        .font(.title)
                    Text("Focus Shield")
                        .font(.title)
                        .fontWeight(.medium)
                }
                .leading()
                .padding(.top)
                .padding(.leading)
                
                List {
                    
                    if isAuthorized {
                        if !proAccess {
                            Button {
                                showingSheet.toggle()
                            } label: {
                                Text("Try Pro")
                                    .foregroundColor(.myColor)
                            }
                        } else {
                            Toggle(isOn: settings.$blockDistractions) {
                                    Text("Block Apps")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color.myColor))
                        }
                    }
                    Section {
                        if isAuthorized {
                            Button {
                                if proAccess {
                                    isPresented = true
                                }
                            } label: {
                                HStack {
                                    Text("Blocked Apps")
                                        .foregroundColor(.white)
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
                        
                    } footer: {
                        Text(isAuthorized ? "You wont have access to these apps during flow": "MyFlow needs to access Screen Time")
                    }
                    
                }
                .padding(.top, -16)
//                            .scrollContentBackground(.hidden)
//                .navigationTitle("Distraction Blocker")
//                .navigationBarTitleDisplayMode(.inline)
            }
//            .background(Color.black.opacity(0.5))

        }
        .sheet(isPresented: $showingSheet) {
            PayWall()
        }
    }
}

