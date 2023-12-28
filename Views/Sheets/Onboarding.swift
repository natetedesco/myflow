//
//  Onboarding.swift
//  MyFlow
//
//  Created by Nate Tedesco on 12/3/23.
//

import SwiftUI

struct OnboardingView: View {
    @State var model: FlowModel
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @AppStorage("showIntro") var showIntro: Bool = false
    
    @State var selectedTab = 1
    @State var showBlur = true
    @State var opacity = 1.0
    
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
                        .padding(.bottom, 2)
                    
                    //                    Text("This app is designed to optimize your time and enhance your focus.")
                    Text("The optimal human experience — where creativity, engagement, and focus are effortless.")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 96)
                    Spacer()
                }
                .tag(1)
                
                // Page 2
                ZStack {
                    AnimatedBlur(offset: false, opacity: 0.6)
                    
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Create your")
                            Text("Flow")
                                .foregroundStyle(.teal)
                        }
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(alignment: .top) {
                            Image(systemName: "rectangle.stack")
                                .foregroundStyle(.teal)
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .padding(.top, 4)
                            
                            VStack(alignment: .leading) {
                                Text("Focus Blocks")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text("Setting a time for each block promotes deeper focus. Blocks can be completed early or extended.")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .top) {
                            Image(systemName: "timer")
                                .foregroundStyle(.teal)
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .padding(.top, 4)
                            
                            VStack(alignment: .leading) {
                                
                                Text("Take Breaks")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text("Breaks can help us stay in a flow, choose to take a break at the end of a focus or start the next focus.")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .top) {
                            Image(systemName: "shield")
                                .foregroundStyle(.teal)
                                .fontWeight(.medium)
                                .font(.largeTitle)
                                .padding(.top, 4)
                            
                            VStack(alignment: .leading) {
                                Text("Block Distractions")
                                    .font(.title3)
                                
                                    .fontWeight(.bold)
                                
                                Text("Block Apps you don't want to disturb you or use during your flow.")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.bottom, 104)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                }
                .tag(2)
            }
            .edgesIgnoringSafeArea(.top)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            
            VStack {
                Spacer()
                Button {
                    if selectedTab == 2 {
                        withAnimation { opacity = 0 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showOnboarding = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                            if !proAccess {
                                model.showPayWall(large: false)
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
        .background(Color.black)
        .opacity(opacity)
    }
}

#Preview {
    OnboardingView(model: FlowModel(), selectedTab: 2)
}

struct miniBlock: View {
    var title: String
    var time: String
    
    var body: some View {
        HStack {
            Gauge(value: 1.0, label: {Text("")})
                .gaugeStyle(.accessoryCircularCapacity)
                .scaleEffect(0.5)
                .tint(.accentColor)
                .padding(.leading, -16)
            
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
