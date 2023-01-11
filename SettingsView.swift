//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settings = Settings()
    @State var hideToolBar = false
    
    var body: some View {
        NavigationView {
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
                .settingsNavigationView()
                Toolbar()
            }
        }
        .accentColor(.myBlue)
    }
    
    var Div: some View {
        Divider()
            .padding(.leading)
    }
    
    var VersionNumber: some View {
        Text("v2.0")
            .foregroundColor(.myBlue)
            .padding(16)
            .kerning(2.0)
            .frame(maxWidth: .infinity, alignment: .center)
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

struct AboutUs: View {
    var body: some View {
        VStack() {
            VStack(spacing: 8) {
                Image("Image")
                    .padding(.bottom)
                
                Text("MyFlow")
                    .foregroundColor(.myBlue)
                    .font(.largeTitle)
                    .fontWeight(.ultraLight)
                    .kerning(3.0)
                
                Text("Focus on what matters.")
                    .font(.footnote)
                
                FootNote(text: "2.0")
            }
            .padding(.bottom, 32)
            
            Text("How can we make better use of our time? In a world full of distractions how can we create an environment to just focus? Focus on the things that really matter. Because we owe that to ourselves. We deserve to realize our dreams and stay true to our passions. Motivation fuels us but consistency moves us forward. That is the idea that created MyFlow.")
                .fontWeight(.light)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(AnimatedBlur(opacity: 0.01))
    }
}

struct HowItWorks: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 64) {
            
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(.myBlue)
                    .font(.largeTitle)
                    .padding(.trailing, 4)
                    .background(Circle()
                        .fill(.ultraThinMaterial.opacity(0.55)))
                //                                .padding(4)
                
                VStack {
                    Text("Create Flows")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Using time blocks or intervals")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "chart.bar")
                    .foregroundColor(.myBlue)
                    .CircularGlassButton()
                    .padding(.leading, -4) // no idea
                VStack {
                    Text("Visualize progress")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Using time blocks or intervals")
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            HStack {
                Image(systemName: "bell")
                    .foregroundColor(.myBlue)
                    .CircularGlassButton()
                VStack {
                    Text("Allow Notifications")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    Text("Required for app functionality")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(AnimatedBlur(opacity: 0.01))
    }
}

struct Feedback: View {
    var body: some View {
        ZStack {
            Text("Please email feedback or support to natetedesco@icloud.com ")
                .padding(.horizontal, 32)
                .frame(maxHeight: .infinity, alignment: .top)
        }
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

