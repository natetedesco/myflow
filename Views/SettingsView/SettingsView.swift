//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    @State var isOn = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Flows
                Headline(text: "Flow")
                VStack {
                    // Start Flow Automatically
                    ToggleBar(text: "Start flow automatically", isOn: $isOn)
                    
                    Div()
                    
                    // Start Break Automatically
                    ToggleBar(text: "Start break automatically", isOn: $isOn)
                }.modifier(CustomGlassNoHPadding())
                
                // Customization
                Headline(text: "Customization")
                VStack(spacing: 16) {
                    // Theme
                    NavigationLink { }
                    label: { NavigationList(text: "Theme", icon: "paintpalette") }
                    
                    Div()
                    
                    // Sound
                    NavigationLink { }
                    label: { NavigationList(text: "Sounds", icon: "speaker") }
                }.modifier(CustomGlassNoHPadding())
                
                // About
                Headline(text: "About")
                VStack(spacing: 16) {
                    // About us
                    NavigationLink { AboutUs() }
                    label: { NavigationLabel(text: "About us", icon: "info.circle") }
                    
                    Div()
                    
                    // How it works
                    NavigationLink { HowItWorks() }
                    label: { NavigationLabel(text: "How it works", icon: "questionmark.circle") }
                    
                    Div()
                    
                    // Rate the app
                    NavigationLink { }
                    label: { NavigationLabel(text: "Rate the app", icon: "star") }
                    
                    Div()
                    
                    // Feedback and support
                    NavigationLink { }
                    label: { NavigationLabel(text: "Feedback and support", icon: "message") }
                }
                .modifier(CustomGlassNoHPadding())
                
                // Version
                VersionNumber(text: "v2.0")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom, 80)
            .navigationTitle("Settings")
            .toolbar { UpgradeButton() }
            .background(AnimatedBlur())
        }
        .accentColor(.myBlue)
    }
}


struct Div: View {
    var body: some View {
        Divider().padding(.leading)
    }
}
