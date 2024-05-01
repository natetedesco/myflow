//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI
import MessageUI
import TipKit

struct SettingsView: View {
    @State var model: FlowModel
    @StateObject var settings = Settings()
    @AppStorage("ProAccess") var proAccess: Bool = false
    @Environment(\.requestReview) var requestReview
    
    @State var activityPresented = false // lags/doesn't show when in settings
    @State var showRateTheApp = false
    @AppStorage("ratedTheApp") var ratedTheApp: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                if !ratedTheApp {
                    Button {
                        ratedTheApp = true
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
                    
                    // About
                    NavigationLink(destination: AboutView(versionNumber: settings.versionNumber)) { Label("About", systemImage: "info.circle") }
                    
                    // Send Feedback
                    Button { settings.isShowingMailView.toggle() } label: { Label("Send Feedback", systemImage: "envelope") }
                    
                    // Share
                    ShareLink(item: URL(string: "https://apps.apple.com/us/app/myflow-focus-time-blocking/id1575798388")!) {
                        Label("Share MyFlow", systemImage: "square.and.arrow.up")
                            .frame(height: 32)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
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
                        
                        // ShowPayWall
                        Button { model.showPayWall() } label: { Label("ShowPayWall", systemImage: "dollarsign.square") }
                        
                        
                        // Reset Ask Focus View
                        Button { ratedTheApp.toggle() } label: { Label("Show Rate the App", systemImage: "square") }
                        
                        // Reset Ask Focus View
                        Button { showRateTheApp.toggle() } label: { Label("Show Rate the App Sheet", systemImage: "square") }
                        
                        // Revoke ScreenTime
                        Button {
                            settings.center.revokeAuthorization { result in
                                switch result {
                                case .success:
                                    settings.isAuthorized = false
                                case .failure(let error):
                                    print("Error revoking authorization: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Label("Revoke ScreenTime", systemImage: "clock.badge.xmark")
                        }
                    }
                }
                
                Text(settings.versionNumber)
                    .foregroundStyle(.teal)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .centered()
                    .monospaced()
                    .listRowSeparator(.hidden, edges: [.bottom])
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
        .sheet(isPresented: $showRateTheApp) {
            AskForRating()
                .sheetMaterial()
                .presentationDetents([.fraction(4/10)])
        }
    }
}

struct MailComposeViewControllerWrapper: UIViewControllerRepresentable {
    @StateObject var settings = Settings()
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(["natetedesco@icloud.com"])
        mailComposeVC.setSubject("MyFlow \(settings.versionNumber)")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        
        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
        }
    }
}

struct AboutView: View {
    var versionNumber: String
    
    var body: some View {
        ScrollView {
            VStack {
                Circles(model: FlowModel(), size: 112, width: 12.0, fill: true)
                
                VStack(spacing: 8) {
                    Text("MyFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Focus on what matters")
                        .font(.callout)
//                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
//                    Text(versionNumber)
//                        .foregroundStyle(.teal)
//                        .font(.caption)
//                        .fontWeight(.medium)
//                        .monospaced()
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("MyFlow optimizes your time by enhancing your focus. Giving your complete focus to a task, and alloting a specific amount of time to it, allows you to complete things faster and with less distraction.")
                    
                    Text("Your feedback and support is greatly appreciated and continues to drive the development of MyFlow.")
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                
                Text("Developed by Nate Tedesco")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}

struct HowItWorks: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("Create your")
                Text("Flow")
                    .foregroundStyle(.teal)
            }
            .font(.system(size: 44))
            .fontWeight(.bold)
            .padding(.top, -32)
            .padding(.bottom, 40)
            
            HStack(alignment: .top) {
                Image(systemName: "rectangle.stack")
                    .foregroundStyle(.teal)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text("Focus Blocks")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Setting a time for each block promotes deeper focus. Blocks can be complete early or extended.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                Image(systemName: "timer")
                    .foregroundStyle(.teal)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text("Take Breaks")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Breaks can help us stay in a flow, choose to take a break at the end of a focus or start the next focus.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                Image(systemName: "shield")
                    .foregroundStyle(.teal)
                    .fontWeight(.medium)
                    .font(.largeTitle)
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text("Block Distractions")
                        .font(.title3)
                    
                        .fontWeight(.bold)
                    
                    Text("Block Apps you don't want to disturb you or use during your flow.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    SettingsView(model: FlowModel())
}

//                        HStack {
//                            Label("Default Focus Length", systemImage: "timer")
//
//                            Spacer()
//
//                            Menu {
//                                Text("options")
//                            } label: {
//                                Text("20:00")
//                                    .font(.callout)
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 6)
//                                    .background(.regularMaterial)
//                                    .cornerRadius(6)
//                                    .foregroundStyle(.white.secondary)
//                                    .padding(.trailing, -2)
//                            }
//                        }
