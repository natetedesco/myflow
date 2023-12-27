//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI
import FamilyControls
import MessageUI
import TipKit

struct SettingsView: View {
    @StateObject var settings = Settings()
    @State var model: FlowModel
    
    @State var developerSettings = true
    
    var body: some View {
        NavigationStack {
            List {
                
                // General
                Section(header: Text("General")) {
                    Toggle(isOn: $settings.notificationsOn) { Label("Notifications", systemImage: "bell") }
                    
                    Toggle(isOn: $settings.liveActivities) { Label("Live Activity", systemImage: "circle.square") }
                }
                
                // Flows
                Section(header: Text("Flows")) {
                    
                    Toggle(isOn: $settings.focusOnStart) { Label("Focus View on Start", systemImage: "timer") }

                    
                    if !isAuthorized {
                        Button {
                            authorizeScreenTime()
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
                        Toggle(isOn: proAccess ? $settings.blockDistractions : $showPayWall) {
                            Label("App Blocker", systemImage: "shield")
                        }
                    }
                    
                    if isAuthorized && settings.blockDistractions {
                        Button {
                            activityPresented = true
                        } label: {
                            HStack {
                                Label("Blocked", systemImage: "xmark.app")
                                Spacer()
                                Text(settings.activitySelection.applicationTokens.count == 0 ? "0 Apps" : "^[\(settings.activitySelection.applicationTokens.count) App](inflect: true)")
                                    .foregroundStyle(.tertiary)
                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .familyActivityPicker(isPresented: $activityPresented, selection: $settings.activitySelection)
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
                }
                
                // About
                Section(header: Text("About")) {
                    
                    NavigationLink(destination: AboutView()) { Label("About", systemImage: "info.circle") }
                    
                    Button { requestReview() } label: { Label("Rate MyFlow", systemImage: "star") }
                    
                    Link(destination: URL(string: "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4")!) {
                        Label("Privacy & Terms", systemImage: "hand.raised")
                    }
                }
                
                if developerSettings {
                    Section(header: Text("Developer")) {
                        Toggle(isOn: $proAccess) { Label("Pro Access", systemImage: "bell") }
                        
                        Toggle(isOn: $settings.shouldResetTips) { Label("Tips", systemImage: "questionmark.circle") }
                        
                        Toggle(isOn: $settings.useDummyData) { Label("Use dummy Data", systemImage: "chart.bar") }
                        
                        Toggle(isOn: $settings.multiplyTotalFlowTime) { Label("Multiply Flow Time", systemImage: "multiply") }
                        
                        Button { showOnboarding = true } label: { Label("Show Onboarding", systemImage: "menucard") }
                        
                        Button { showPayWall = true } label: { Label("ShowPayWall", systemImage: "dollarsign.square") }

                        Button { settings.showFocusByDefault = true } label: { Label("ShowFocusByDefaultSheet", systemImage: "square") }

                        
                        Button {
                            center.revokeAuthorization { result in
                                switch result {
                                case .success:
                                    isAuthorized = false
                                case .failure(let error):
                                    print("Error revoking authorization: \(error.localizedDescription)")
                                }
                            }
                        } label: {
                            Label("Revoke ScreenTime", systemImage: "clock.badge.xmark")
                        }
                    }
                }
                
                Text("v3.1")
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
                            showPayWall.toggle()
                        } label: {
                            Text("Pro")
                                .fontWeight(.medium)
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingMailView.toggle()
                    } label: {
                        Image(systemName: "envelope")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .sheet(isPresented: $showPayWall) {
            PayWall(detent: $detent)
                .presentationCornerRadius(32)
                .presentationBackground(.regularMaterial)
                .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                .interactiveDismissDisabled(detent == .large)
                .presentationDragIndicator(detent != .large ? .visible : .hidden)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailComposeViewControllerWrapper(isShowing: $isShowingMailView)
                .ignoresSafeArea()
        }
    }
    
    func authorizeScreenTime() {
        Task { do {
            try await center.requestAuthorization(for: .individual)
            if proAccess {
                settings.blockDistractions = true
            }
            isAuthorized = true
        } catch {
            print("error")
        }}
    }
    
    
    let center = AuthorizationCenter.shared
    @State var activityPresented = false
    @AppStorage("ScreenTimeAuthorized") var isAuthorized: Bool = false
    
    @State private var showPayWall = false
    @State var detent = PresentationDetent.large
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @Environment(\.requestReview) var requestReview
    @State private var isShowingMailView = false
    
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
}

struct MailComposeViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(["natetedesco@icloud.com"])
        mailComposeVC.setSubject("MyFlow 3.1")
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
    var body: some View {
        ScrollView {
            VStack {
                Circles(model: FlowModel(), size: 112, width: 12.0, fill: true)
                
                VStack(spacing: 8) {
                    Text("MyFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Focus on what matters.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    Text("v3.1")
                        .foregroundStyle(.teal)
                        .font(.caption)
                        .fontWeight(.medium)
                        .monospaced()
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("MyFlow optimizes your time by enhancing your focus. Giving your complete focus to a task, and alloting a specific amount of time to it, allows you to complete things faster and with less distraction.")
                    
                    
                    Text("Your feedback and support is greatly appreciated and continues to drive the development of MyFlow.")
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                
                Spacer()
                
                Text("Developed by Nate Tedesco")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    SettingsView(model: FlowModel())
}
