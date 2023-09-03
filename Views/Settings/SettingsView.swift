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
    @AppStorage("showLiveActivities") var showLiveActivities: Bool = true
    let center = AuthorizationCenter.shared
    @AppStorage("ScreenTimeAuthorized") var isAuthorized: Bool = false
    @State var isPresented = false
    
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    
                    if !proAccess
                    {
                        VStack {
                            ZStack {
                                Image("Live Activities")
                                    .resizable()
                                    .offset(y: 35)
                                    .scaledToFill()
                                    .frame(height: 136)
                                    .clipped()
                                    .padding(-16)
                                    .padding(.bottom)
                                
                                Button {
                                    showLiveActivities = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .CircularGlassButton(padding: 8)
                                        .trailing()
                                        .padding(.trailing, -4)
                                        .top()
                                }
                            }
                            
                            HStack {
                                Text("Live Activities")
                                    .font(.title3.bold())
                                Text("New")
                                    .foregroundColor(.myColor)
                                    .font(.caption2)
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 4)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(5)
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                            
                            
                            Button {
                                showingSheet = true
                            } label: {
                                Text("View MyFlow Pro")
                                    .frame(maxWidth: .infinity)
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.myColor)
                                    .cornerRadius(10)
                            }
                        }
                        .cardGlass()
                        .padding(.top)
                    }
                    
                    
                    CustomHeadline(text: "General")
                    VStack(spacing: 16) {
                        ToggleBar(text: "Notifications", icon: "bell", isOn: settings.$notificationsOn)
                        Div
                        
                        //                     Only for demoing
                        ToggleBar(text: "Pro Access", icon: "bell", isOn: $proAccess)
                        Div
                        
                        
                        HStack {
                            Image(systemName: "shield")
                                .frame(width: 20)
                            Text("App Blocker")
                            
                            Spacer()
                            
                            if !isAuthorized {
                                Button { Task { do {
                                    try await center.requestAuthorization(for: .individual)
                                    isAuthorized = true
                                } catch { print("error") } }
                                } label: {
                                    Text("Authorize")
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 12)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(5)
                                }
                            } else {
                                
                                HStack {
                                    if settings.blockDistractions {
                                        Button {
                                            if proAccess {
                                                isPresented = true
                                            }
                                        } label: {
                                            Spacer()
                                            Text("List")
                                                .foregroundColor(.gray)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 12)
                                                .background(.ultraThinMaterial)
                                                .cornerRadius(5)
                                                .padding(.trailing)
                                                .familyActivityPicker(isPresented: $isPresented, selection: $model.activitySelection)
                                        }
                                    }
                                    Toggle(isOn: proAccess ? $settings.blockDistractions : $showingSheet) {
                                        Text("")
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: Color.myColor))
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Div
                        
                        NavigationLink(destination: ThemePicker()) { NL(text: "Themes", icon: "photo") }
                        
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
            }
            .background(.regularMaterial)
            .navigationTitle("Settings")
//            .toolbar{ upgradeButton }
            .accentColor(.myColor)
            .sheet(isPresented: $showingSheet) {
                PayWall()
            }
        }
    }
    
//    @ViewBuilder var upgradeButton: some View {
//        if !proAccess {
//
//            ZStack {
//                Button {
//                    dismiss()
//                } label: {
//                    Text("Done")
//                }
//            }
//        }
//    }
    
    var Div: some View {
        Divider()
            .padding(.leading)
    }
    
    var VersionNumber: some View {
        Text("v2.3.1")
            .foregroundColor(.myColor)
            .font(.footnote)
            .padding(16)
            .centered()
            .monospaced()
    }
    
    var UpgradeButton: some View {
        Button {
        } label: {
            Text("Upgrade")
                .smallButtonGlass()
        }
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
            
            HStack {
                Text(settings.blockDistractions ? "On" : "Authorize")
                Image(systemName: "chevron.right")
                    .font(.system(size: 15))
            }
            .opacity(settings.blockDistractions ? 0.5 : 1.0)
            .foregroundColor(settings.blockDistractions ? .gray : .gray)
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
    var icon: String
    
    @Binding var isOn: Bool
    var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(text)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.myColor))
        .padding(.horizontal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: FlowModel())
    }
}

            //            .background(Image(theme).resizable().ignoresSafeArea().opacity(theme == "default" ? 0.0 : 1.0))
