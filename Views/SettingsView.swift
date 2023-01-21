//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settings = Settings()
    
    var body: some View {
        ZStack {
            ScrollView {
                // Flows
                CustomHeadline(text: "Flow")
                VStack {
                    ToggleBar(text: "Start flow automatically", isOn: $settings.startFlowAutomatically)
                    Div
                        .padding(.vertical, 2)
                    ToggleBar(text: "Start break automatically", isOn: $settings.startBreakAutomatically)
                }
                .padding(.vertical, 12)
                .background(.black.opacity(0.6))
                .cornerRadius(25.0)
                .padding(.horizontal)
                
                // About
                CustomHeadline(text: "About")
                VStack(spacing: 16) {
                    NavigationLink(destination: AboutUs()) { NL(text: "About us", icon: "info.circle") }
                    Div
                    NavigationLink(destination: HowItWorks()) { NL(text: "How it works", icon: "questionmark.circle") }
                    Div
                    NavigationLink(destination: Feedback()) { NL(text: "Feedback and support", icon: "message") }
                }
                .cardGlassNP()
                
                VersionNumber
            }
            .navigationView(title: "Settings")
            Toolbar()
        }
    }
    
    var Div: some View {
        Divider()
            .padding(.leading)
    }
    
    var VersionNumber: some View {
        Text("v2.0")
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

struct NL: View {
    var text: String
    var icon: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(text)
            Spacer()
        }
        .padding(.horizontal)
        .foregroundColor(.white)
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
            Text(text)
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
        .padding(.horizontal)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
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

