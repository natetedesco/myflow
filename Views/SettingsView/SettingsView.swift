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
            ZStack {
                AnimatedBlur()
                ScrollView {
                    
                    // Flows
                    Headline(text: "Flow")
                    VStack {
                        // Start Flow Automatically
                        ToggleBar(text: "Start flow automatically", isOn: $isOn)
                            .padding(.top, 8)
                        
                        Divider().padding(.leading)
                        
                        // Start Break Automatically
                        ToggleBar(text: "Start break automatically", isOn: $isOn)
                            .padding(.bottom, 8)
                    }
                    .modifier(CustomGlassNoPadding())
                    
                    // Customization
                    Headline(text: "Customization")
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Theme
                        NavigationLink {
                            
                        } label: {
                            SettingsNavigationList(text: "Theme", icon: "paintpalette")
                                .padding(.top)
                        }

                        Divider().padding(.leading)
                        
                        // Sound
                        NavigationLink {
                            
                        } label: {
                            SettingsNavigationList(text: "Sounds", icon: "speaker")
                                .padding(.bottom)
                        }
                    }
                    .modifier(CustomGlassNoPadding())
                    
                    // About
                    Headline(text: "About")
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // About us
                        NavigationLink {
                            AboutUs()
                        } label: {
                            SettingsNavigation(text: "About us", icon: "info.circle")
                                .padding(.top)
                        }

                        Divider().padding(.leading)
                        
                        // How it works
                        NavigationLink {
                            HowItWorks()
                        } label: {
                            SettingsNavigation(text: "How it works", icon: "questionmark.circle")
                        }
                        
                        Divider().padding(.leading)
                        
                        // Rate the app
                        NavigationLink {
                            
                        } label: {
                            SettingsNavigation(text: "Rate the app", icon: "star")
                        }
                        
                        Divider().padding(.leading)
                        
                        // Feedback and support
                        NavigationLink {
                            
                        } label: {
                            SettingsNavigation(text: "Feedback and support", icon: "message")
                                .padding(.bottom)
                        }
                    }
                    .modifier(CustomGlassNoPadding())

                    // Version
                    VersionNumber(text: "v2.0")
                }
                .padding(.bottom, 80)
                Toolbar(model: model)
            }
            .navigationTitle("Settings")
            .toolbar {
                UpgradeButton()
            }
        }.accentColor(.myBlue)
    }
}

