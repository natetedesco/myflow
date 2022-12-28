//
//  SettingsView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/21.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    @State var startFlowAutomatically = false
    @State var startBreakAutomatically = false

    
    var body: some View {
        NavigationView {
            ScrollView {
                // Flows
                Headline(text: "Flow")
                VStack {
                    // Start Flow Automatically
                    ToggleBar(text: "Start flow automatically", isOn: $startFlowAutomatically)
                    
                    Div
                    
                    // Start Break Automatically
                    ToggleBar(text: "Start break automatically", isOn: $startBreakAutomatically)
                }
                .modifier(CardGlassNP())
                
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
//                .modifier(CardGlassNP())
                
                // About
                Headline(text: "About")
                VStack(spacing: 16) {
                    
                    // About us
                    NavigationLink(destination: AboutUs()) {
                        NavigationLabel(text: "About us", icon: "info.circle") }

                    Div
                    
                    // How it works
                    NavigationLink(destination: HowItWorks()) {
                        NavigationLabel(text: "How it works", icon: "questionmark.circle") }
                    
                    Div
                    
                    // Feedback and support
                    NavigationLink { }
                label: { NavigationLabel(text: "Feedback and support", icon: "message") }
                }
                .modifier(CardGlassNP())
                
                // Version
                VersionNumber
            }
            .padding(.bottom, 80)
            .navigationTitle("Settings")
            .toolbar { UpgradeButton }
            .background(AnimatedBlur())
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
                .modifier(SmallButtonGlass())
        }
    }
}

struct NavigationLabel: View {
    var text: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.white)
            Text(text)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct NavigationList: View {
    var text: String
    var icon: String
    
    var body: some View {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
            }
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

struct SettingToggle: View {
    var text: String
    
    var body: some View {
        VStack {
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) { Text(text) }
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
            //                .padding(.horizontal, 30)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 180, alignment: .leading)
        .background(.black.opacity(0.5))
        .cornerRadius(25.0)
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
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
                    
                    Text("MyFlow")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Encouraging a flow state of mind.")
                    
                    Text("v2.0")
                        .font(.footnote)
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
