//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI
import TipKit

struct SettingsView: View {
    @State var model: FlowModel
    @StateObject var settings = Settings()
    @AppStorage("ProAccess") var proAccess: Bool = false
    @Environment(\.requestReview) var requestReview
    
    @State var activityPresented = false // lags/doesn't show when in settings
    
    @State var showRateTheApp = false
    @State var showWhatsNew = false

    @State var taps = 0
    
    var body: some View {
        NavigationStack {
            List {
                if !settings.ratedTheApp {
                    Button {
                        settings.ratedTheApp = true
                        requestReview()
                    } label: {
                        
                        Text("Rate MyFlow")
                            .foregroundStyle(.white)
                            .fontWeight(.medium)
                            .font(.footnote)
                            .padding(10)
                            .padding(.horizontal, 2)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.8)]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            ))
                            .cornerRadius(16)
                    }
                    .listRowSeparator(.hidden, edges: [.top, .bottom])
                }

                // General
                Section(header: Text("General")) {
                    
                    // Notifications
                    Toggle(isOn: $settings.notificationsOn) { Label("Notifications", systemImage: "bell") }
                    
                    // Live Activity
                    Toggle(isOn: $settings.liveActivities) { Label("Live Activity", systemImage: "circle.square") }
                }
                
                // Flows
                Section(header: Text("Flows")) {
                    
                    // App Blockler
                    if !model.settings.isAuthorized {
                        Button {
                            model.settings.authorizeScreenTime()
                        } label: {
                            HStack {
                                Label("App Blocker", systemImage: "shield")
                                Spacer()
                                Text("Authorize")
                                    .foregroundColor(.teal)
                                    .font(.callout)
                            }
                        }
                    } else {
                        Toggle(isOn: proAccess ? $model.settings.blockDistractions : $model.showPayWall) {
                            Label("App Blocker", systemImage: "shield")
                        }
                    }
                    
                    // Blocked Apps
                    if model.settings.isAuthorized && model.settings.blockDistractions {
                        Button {
                            activityPresented = true
                        } label: {
                            HStack {
                                Label("Blocked", systemImage: "xmark.app")
                                Spacer()
                                Text(model.settings.activitySelection.applicationTokens.count == 0 ? "0 Apps" : "^[\(model.settings.activitySelection.applicationTokens.count) App](inflect: true)")
                                    .foregroundStyle(.tertiary)
                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .familyActivityPicker(isPresented: $activityPresented, selection: $model.settings.activitySelection)
                        .onChange(of: model.settings.activitySelection) { oldValue, newValue in
                            model.settings.saveActivitySelection()
                        }
                    }
                    
                    // Focus View as Default
                    Toggle(isOn: $settings.focusOnStart) { Label("Focus View on Start", systemImage: "timer") }
                    
                }
                
                // About
                Section(header: Text("About")) {
                    
                    // Send Feedback
                    Button { settings.isShowingMailView.toggle() } label: { Label("Send Feedback", systemImage: "megaphone") }
                    
                    // Share
                    ShareLink(item: URL(string: "https://apps.apple.com/us/app/myflow-focus-time-blocking/id1575798388")!) {
                        Label("Share MyFlow", systemImage: "person.2")
                            .frame(height: 32)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // About
                    NavigationLink(destination: AboutView()) { Label("About", systemImage: "info.circle") }
                    
                    // Privacy & Terms
                    Link(destination: URL(string: "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4")!) {
                        Label("Privacy & Terms", systemImage: "hand.raised")
                    }
                }
                
                // Developer
                if settings.developerSettings {
                    Section(header: Text("Developer")) {
                        
                        // Pro Access
                        Toggle(isOn: $proAccess) { Label("Pro Access", systemImage: "bell") }
                        
                        // Tips
                        Toggle(isOn: $settings.shouldResetTips) { Label("Tips", systemImage: "questionmark.circle") }
                        
                        // Use Dummy Data
                        Toggle(isOn: $settings.useDummyData) { Label("Use Dummy Data", systemImage: "chart.bar") }
                        
                        // Multiply Flow Time
                        Toggle(isOn: $settings.multiplyTotalFlowTime) { Label("Multiply Flow Time", systemImage: "multiply") }
                        
                        // Show Onboarding
                        Toggle(isOn: $settings.showOnboarding) { Label("Show Onboarding", systemImage: "menucard") }
                        
                        // Reset Ask Focus View
                        Toggle(isOn: $settings.ratedTheApp) { Label("Rated the App", systemImage: "star") }
                        
                        // Revoke ScreenTime
                        Button {
                            settings.center.revokeAuthorization { result in
                                switch result { case .success: settings.isAuthorized = false
                                case .failure(let error): print("Error: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Label("Revoke ScreenTime", systemImage: "clock.badge.xmark")
                        }
                    }
                    
                    // What's New Sheet
                    Button { showWhatsNew.toggle() } label: { Label("What's New", systemImage: "sparkles") }
                    
                }
                
                Text(settings.versionNumber)
                    .foregroundStyle(.teal)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .centered()
                    .monospaced()
                    .listRowSeparator(.hidden, edges: [.bottom])
                    .onTapGesture {
                        taps += 1
                    }
                    .onLongPressGesture {
                        if taps == 5 {
                            settings.developerSettings.toggle()
                            softHaptic()
                        }
                    }
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 56)
            .navigationTitle("Settings")
            .toggleStyle(SwitchToggleStyle(tint: Color.teal))
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    if !proAccess {
                        Button {
                            model.showPayWall()
                        } label: {
                            Text("Pro")
                                .fontWeight(.medium)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $settings.isShowingMailView) {
            MailComposeViewControllerWrapper(isShowing: $settings.isShowingMailView)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView()
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    SettingsView(model: FlowModel())
}
