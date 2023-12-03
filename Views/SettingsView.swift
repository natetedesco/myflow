//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI
import FamilyControls
import MessageUI

struct SettingsView: View {
    @StateObject var settings = Settings()
    @Bindable var model: FlowModel
    @Environment(\.requestReview) var requestReview
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @State private var showPayWall = false
    @State var detent = PresentationDetent.large
    
    let center = AuthorizationCenter.shared
    @AppStorage("ScreenTimeAuthorized") var isAuthorized: Bool = false
    
    @State private var isShowingMailView = false
    
    var body: some View {
        
        NavigationView {
                
                ScrollView {
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Button {
                            isShowingMailView.toggle()
                        } label: {
                            NL(text: "Send Feedback", icon: "envelope", color: .white)
                                .fontWeight(.medium)
                            
                        }
                        .sheet(isPresented: $isShowingMailView) {
                            MailComposeViewControllerWrapper(isShowing: $isShowingMailView)
                        }
                    }
                    .padding(.vertical)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [.myColor.opacity(0.8), .myColor.opacity(0.4)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .background(.bar)
                    .cornerRadius(20)
                    .shadow(color: Color.myColor.opacity(0.3), radius: 6)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    
                    // General
                    CustomHeadline(text: "GENERAL")
                    VStack(spacing: 12) {
                        ToggleBar(text: "Notifications", icon: "bell", isOn: $settings.notificationsOn)
                        
                        Div
                        
                        ToggleBar(text: "Live Activity", icon: "circle.square", isOn: $settings.liveActivities)
                        
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
                                        .foregroundColor(.myColor)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 12)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(5)
                                }
                            } else {
                                
                                Toggle(isOn: proAccess ? $settings.blockDistractions : $showPayWall) {
                                    Text("")
                                }
                                .toggleStyle(SwitchToggleStyle(tint: Color.myColor))
                                
                            }
                        }
                        .padding(.horizontal)
                        
//                        VStack {
//                            if isAuthorized {
//                                Button {
////                                    if proAccess {
////                                        isPresented = true
////                                    }
//                                } label: {
//                                    HStack {
//                                        Text("Blocked Apps")
//                                            .foregroundColor(.white)
////                                            .fontWeight(.medium)
//                                        Spacer()
//                                        if model.activitySelection.applicationTokens.isEmpty && model.activitySelection.categoryTokens.isEmpty &&
//                                            model.activitySelection.webDomainTokens.isEmpty {
//                                            Text("None")
//                                                .foregroundColor(.gray)
//                                        } else {
//                                            if !proAccess {
//                                                Image(systemName: "lock.fill")
//                                                    .foregroundColor(.gray)
//                                            } else {
//                                                Text(Image(systemName: "chevron.right"))
//                                                    .foregroundColor(.gray)
//                                                    .fontWeight(.semibold)
//                                            }
//                                            
//                                        }
//                                    }
//                                }
////                                .familyActivityPicker(isPresented: $isPresented, selection: $model.activitySelection)
//                            } else {
//                                Button {
//                                    Task {
//                                        do {
//                                            try await center.requestAuthorization(for: .individual)
//                                            isAuthorized = true
//                                        } catch {
//                                            print("error")
//                                        }
//                                    }
//                                } label: {
//                                    Text("Authorize")
//                                        .foregroundColor(.myColor)
//                                }
//                            }
//                            
//                            // App Icons
//                            if !model.activitySelection.applicationTokens.isEmpty {
////                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 48))], spacing: 16) {
//                                ScrollView(.horizontal) {
//
//                                    HStack {
//                                        ForEach(Array(model.activitySelection.applicationTokens), id: \.self) { applicationToken in
//                                            Label(applicationToken)
//                                                .labelStyle(.iconOnly)
//                                                .scaleEffect(1.5)
//                                            
//                                        }
//                                    }
//                                }
//                                .padding(.vertical, 8)
//                            }
//                        }
//                        .padding(.horizontal)
//                        .frame(maxWidth: .infinity)
//                        .background(.ultraThickMaterial)
//                        .cornerRadius(24)
                        
                        
                    }
                    .cardGlassNP()
                    
                    
                    // About
                    CustomHeadline(text: "ABOUT")
                    VStack(spacing: 12) {
                        
                        Link(destination: URL(string: "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4")!) {
                            NL(text: "Privacy & Terms", icon: "hand.raised")
                        }
                        
                        Div
                        
                        Button {
                            requestReview()
                        } label: {
                            NL(text: "Rate the App", icon: "star")
                        }
                        
                    }
                    .cardGlassNP()
                    
                    // DEMO
                    CustomHeadline(text: "DEMO")
                    VStack {
                        ToggleBar(text: "Pro Access", icon: "bell", isOn: $proAccess)
                    }
                    .cardGlassNP()
                    
                    VersionNumber
                }
            .navigationTitle("Settings")
            .accentColor(.myColor)
            .sheet(isPresented: $showPayWall) {
                PayWall(detent: $detent)
                    .presentationCornerRadius(40)
                    .presentationBackground(.bar)
                    .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                    .interactiveDismissDisabled(detent == .large)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    
    var Div: some View {
        Divider()
            .padding(.leading)
    }
    
    var VersionNumber: some View {
        Text("v3.0")
            .foregroundColor(.myColor)
            .font(.callout)
            .fontWeight(.medium)
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
    var color: Color = .white
    
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
        .foregroundColor(color)
        .padding(.vertical, 4)
    }
}

struct NLT: View {
    var text: String
    var icon: String
    var model: FlowModel
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

