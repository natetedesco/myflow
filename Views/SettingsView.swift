//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI
import FamilyControls

struct SettingsView: View {
    @StateObject var settings = Settings()
    @ObservedObject var model: FlowModel
    @State private var showingSheet = false
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                
                CustomHeadline(text: "General")
                VStack(spacing: 16) {
                    ToggleBar(text: "Notifications", isOn: settings.$notificationsOn)
                    Div
                    
                    // Only for demoing
                    ToggleBar(text: "Pro Access", isOn: $proAccess)
                    Div
                    
                    
                    NavigationLink(destination: DistractionBlocker(model: model)) { NLT(text: "Block Distractions", icon: "shield", model: model) }
                }
                .cardGlassNP()
                
                // About
                CustomHeadline(text: "About")
                VStack(spacing: 16) {
                    NavigationLink(destination: AboutUs()) { NL(text: "About us", icon: "info.circle") }
                    Div
                    NavigationLink(destination: HowItWorks()) { NL(text: "How it works", icon: "questionmark.circle") }
                    Div
                    NavigationLink(destination: Feedback()) { NL(text: "Feedback & support", icon: "message") }
                }
                .cardGlassNP()
                
                VersionNumber
            }
            .navigationView(title: "Settings", button: upgradeButton)
            
            Toolbar()
        }
        .fullScreenCover(isPresented: $showingSheet) {
            PayWall()
        }
    }
    
    @ViewBuilder var upgradeButton: some View {
        if !proAccess {
            
            ZStack {
                Button {
                    showingSheet.toggle()
                } label: {
                    Text("Unlock Pro")
                    //                        .padding(.trailing)
                        .smallButtonGlass()
                    //            .foregroundColor(.clear)
                }
            }
        }
    }
    
    var Div: some View {
        Divider()
            .padding(.leading)
    }
    
    var VersionNumber: some View {
        Text("v2.1")
            .myBlue()
            .padding(16)
            .kerning(2.0)
            .centered()
    }
    
    var UpgradeButton: some View {
        Button {
        } label: {
            Text("Upgrade")
                .smallButtonGlass()
        }
    }
}

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
            List {
                
                if isAuthorized {
                    if !proAccess {
                        Button {
                            showingSheet.toggle()
                        } label: {
                            Text("Unlock Pro")
                                .foregroundColor(.myBlue)
                        }
                    } else {
                        Toggle(isOn: settings.$blockDistractions) {
                            Text("Block Distractions")
                            
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
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
                        }
                    }
                    
                } footer: {
                    Text(isAuthorized ? "You wont have access to these apps during flow": "MyFlow needs to access Screen Time")
                }
            }
        }
        .navigationTitle("Block Distractions")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showingSheet) {
            PayWall() }
    }
}

struct NL: View {
    var text: String
    var icon: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .opacity(0.5)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .padding(.vertical, 4)
    }
}

struct NLT: View {
    var text: String
    var icon: String
    @ObservedObject var model: FlowModel
    @StateObject var settings = Settings()
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(text)
            Spacer()
            Text(settings.blockDistractions ? "On" : "Off")
            .opacity(0.5)
            Image(systemName: "chevron.right")
                .font(.system(size: 15))
                .opacity(0.5)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .padding(.vertical, 4)
    }
}

struct NavigationList: View {
    var text: String
    var icon: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(text)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}

struct ToggleBar: View {
    var text: String
    @Binding var isOn: Bool
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: "bell")
                    .frame(width: 20)
                Text(text)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
        .padding(.horizontal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: FlowModel())
    }
}

// Customization
//                Headline(text: "Customization")
//                VStack(spacing: 16) {
//                    // Theme
//                    NavigationLink { }
//                label: { NavigationList(text: "Theme", icon: "paintpalette") }
//                    Div
//                    // Sound
//                    NavigationLink { }
//                label: { NavigationList(text: "Sounds", icon: "speaker") }
//                }

// Flows
//                CustomHeadline(text: "Flow")
//                VStack {
//                    ToggleBar(text: "Start flow automatically", isOn: $settings.startFlowAutomatically)
//                    Div
//                        .padding(.vertical, 2)
//                    ToggleBar(text: "Start break automatically", isOn: $settings.startBreakAutomatically)
//                }
//                .padding(.vertical, 12)
//                .background(.black.opacity(0.6))
//                .cornerRadius(25.0)
//                .padding(.horizontal)
