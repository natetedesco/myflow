//
//  Onboarding.swift
//  MyFlow
//
//  Created by Nate Tedesco on 12/3/23.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @AppStorage("showIntro") var showIntro: Bool = false
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @State var selectedTab = 1
    
    @State var showBlur = true
    
    
    var body: some View {
        ZStack {
            
            TabView(selection: $selectedTab) {
                
                // Page 1
                VStack {
                    Spacer()
                    
                    Circles(model: FlowModel(), size: 160, width: 16.0, fill: true)
                        .padding(.bottom)
                    
                    Text("Experience Flow")
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    
                    Text("This app is designed to optimize your time and enhance your focus.")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 96)
                    Spacer()
                }
                .tag(1)
                
                // Page 2
                VStack {
                    Spacer()
                    
                    VStack {
                        Divider()
                        miniBlock(title: "Writing", time: "30:00")
                            .padding(.vertical, -16)
                        Divider()
                        miniBlock(title: "Editing", time: "20:00")
                            .padding(.vertical, -16)
                        Divider()
                        miniBlock(title: "Revision", time: "10:00")
                            .padding(.vertical, -16)
                        Divider()
                    }
                    .padding(.horizontal, 80)
                    
                    Text("Focus Time Blocking")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    
                    Text("Set a time for each focus in your flow. Once completed, extend, start the next focus, or take a break.")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 32)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    Spacer()
                }
                .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            
            VStack {
                Spacer()
                    Button {
                        if selectedTab == 2 {
                            showOnboarding = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                if !proAccess {
                                    showIntro = true
                                }
                            }
                        } else {
                            withAnimation { selectedTab += 1 }
                        }
                        softHaptic()
                    } label: {
                        Text(selectedTab == 2 ? "Let's Flow" : "Continue")
                            .foregroundStyle(.teal)
                            .fontWeight(.medium)
                    }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
            
        }
    }
}

#Preview {
    OnboardingView()
}

struct miniBlock: View {
    var title: String
    var time: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Gauge(value: 1.0, label: {Text("")})
                        .gaugeStyle(.accessoryCircularCapacity)
                        .scaleEffect(0.5)
                        .tint(.accentColor)
                        .padding(.leading, -16)
                }
                
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
                    .padding(.leading, -16)
                
                Spacer()
                
                Text(time)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}
