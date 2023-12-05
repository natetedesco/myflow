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
    
    var body: some View {
        NavigationView {
            List {
                
                // Flows
                Section(header: Text("Flows")) {
                    
                    if !isAuthorized {
                        Button { Task { do {
                            try await center.requestAuthorization(for: .individual)
                            if proAccess {
                                settings.blockDistractions = true
                            }
                            isAuthorized = true
                        } catch {
                            print("error")
                        }
                        }
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
                                Label("Blocked Apps", systemImage: "xmark.app")
                                Spacer()
                                Text("^[\(settings.activitySelection.applicationTokens.count) App](inflect: true)")
                                    .foregroundStyle(.tertiary)
                                
                                Image(systemName: "chevron.right")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .familyActivityPicker(isPresented: $activityPresented, selection: $settings.activitySelection)
                    }
                    
                    Toggle(isOn: $settings.focusMode) {
                        Label("Focus Mode", systemImage: "timer")
                    }
                    
                }
                
                // General
                Section(header: Text("General")) {
                    Toggle(isOn: $settings.notificationsOn) {
                        Label("Notifications", systemImage: "bell")
                    }
                    
                    Toggle(isOn: $settings.liveActivities) {
                        Label("Live Activity", systemImage: "circle.square")
                    }
                }
                
                // About
                Section(header: Text("About")) {
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate MyFlow", systemImage: "star")
                    }
                    
                    Link(destination: URL(string: "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4")!) {
                        Label("Privacy & Terms", systemImage: "hand.raised")
                    }
                    
                    
                    Button {
                        isShowingMailView.toggle()
                    } label: {
                        HStack {
                            Label("Share Feedback", systemImage: "envelope")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Section(header: Text("Developer")) {
                    Toggle(isOn: $proAccess) {
                        Label("Pro Access", systemImage: "bell")
                    }
                    
                    Button {
                        showOnboarding = true
                    } label: {
                        Label("Show Onboarding", systemImage: "menucard")
                    }
                    
                    Toggle(isOn: $shouldResetTips) {
                        Label("Tips", systemImage: "questionmark.circle")
                    }
                    
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
                
                Text("v3.1")
                    .foregroundColor(.teal)
                    .font(.callout)
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
                        }
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
        }
    }
    
    @AppStorage("shouldResetTips") var shouldResetTips: Bool = true
    
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
        mailComposeVC.setSubject("MyFlow 3.0")
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

struct DemoStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center) {    // << here !!
            configuration.icon
            configuration.title
        }
    }
}
