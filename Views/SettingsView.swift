//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: FlowModel
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                // Flows
                Headline(text: "Flow")
                VStack {
                    ToggleBar(text: "Start flow automatically", isOn: $startFlowAutomatically)
                    Div
                    ToggleBar(text: "Start break automatically", isOn: $startBreakAutomatically)
                }
                .cardGlassNP()
                
                // About
                Headline(text: "About")
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
        }
        .accentColor(.myBlue)
    }
    
    var Div: some View {
        Divider().padding(.leading)
    }
    
    var VersionNumber: some View {
        Text("v2.0")
            .foregroundColor(.myBlue)
            .padding(32)
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
        ZStack {
            AnimatedBlurOpaque()
            VStack() {
                VStack(spacing: 8) {
                    Image("Image")
                        .padding(.bottom)
                    
                    LargeTitle(text: "MyFlow")
                    
                    Text("Encouraging a flow state of mind.")
                    
                    FootNote(text: "v2.0")
                }
                .padding(.bottom, 32)
                
                Text("A simple but powerful tool to improve focus, performance, creativity. Create flows, routines, and personalized time management systems to stay on track and track your progress. ")
                    .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
}

struct HowItWorks: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            HStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width: 30)
                    .foregroundColor(.myBlue)
                    .padding(.trailing)
                DescriptionView(
                    title: "Flow",
                    text: "Time for productivity and focus")
            }
            
            HStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .frame(width: 30)
                    .foregroundColor(.gray)
                    .padding(.trailing)
                DescriptionView(
                    title: "Break",
                    text: "Time to rest your body and mind")
            }
            
            
            HStack {
                Image(systemName: "play.fill")
                    .foregroundColor(.myBlue)
                    .font(.system(size: 30))
                    .padding(.trailing)
                DescriptionView(
                    title: "Start",
                    text: "Cycle between your flows and breaks")
            }
            Spacer()
        }
    }
}

struct Feedback: View {
    var body: some View {
        ZStack {
            AnimatedBlurOpaque()
            Text("MyFlow is currently in the Alpha stage. Please email feedback or support to natetedesco@icloud.com ")
                .padding(.horizontal, 32)
                .frame(maxHeight: .infinity, alignment: .top)
            
//            Spacer()
        }
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

