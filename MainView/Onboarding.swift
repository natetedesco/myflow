//
//  Onboarding.swift
//  MyFlow
//  Created by Nate Tedesco on 12/3/23.
//

import SwiftUI

struct OnboardingView: View {
    @State var model: FlowModel
    @AppStorage("ProAccess") var proAccess: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @AppStorage("showIntro") var showIntro: Bool = false
    
    @State var selectedTab = 0
    @State var showBlur = true
    @State var opacity = 1.0
    
    var body: some View {
        ZStack {
            
            Circle()
                .foregroundStyle(.teal.opacity(0.5))
                .frame(height: 400)
                .blur(radius: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, -200)
                .padding(.leading, -300)
            
            
            Circle()
                .foregroundStyle(.teal.opacity(0.5))
                .frame(height: 400)
                .blur(radius: 300)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, -200)
                .padding(.leading, -300)
            
            TabView(selection: $selectedTab) {
                
                VStack {
                    Spacer()
                    
                    Circles(model: model, size: 80, width: 8, fill: true)

                    Text("Experience Flow")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                    Text("The optimal human experience. Where creativity and focus are effortless.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button {
                        softHaptic()
                        withAnimation { selectedTab += 1 }
                    } label: {
                        Text("Continue")
                            .foregroundStyle(.teal)
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 48)
                    }
                }
                .padding(.horizontal, 32)
                .tag(0)
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text("Create your")
                            .padding(.top, 48)
                        Text("Flow")
                            .foregroundStyle(.teal)
                    }
                    .fontWeight(.bold)
                    .font(.system(size: 44))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 44)
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Image(systemName: "rectangle.stack")
                            .foregroundStyle(.teal)
                            .font(.title)
                            .fontWeight(.medium)
                        
                        VStack(alignment: .leading) {
                            Text("Focus Blocks")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Flexible blocks of time for deep, uninterrupted focus on a single task.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Image(systemName: "timer")
                            .foregroundStyle(.teal)
                            .font(.title)
                            .fontWeight(.medium)
                        
                        VStack(alignment: .leading) {
                            Text("Take Breaks")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Take timed breaks between blocks to recharge focus or stay in flow.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Image(systemName: "shield")
                            .foregroundStyle(.teal)
                            .fontWeight(.medium)
                            .font(.title)
                        
                        VStack(alignment: .leading) {
                            Text("Block Distractions")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Block apps you don't want to disturb or distract you during your flow.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom)
                    
                    Spacer()
                    
                    Button {
                        softHaptic()
                        if proAccess {
                            withAnimation { opacity = 0 }
                            showOnboarding = false
                        } else {
                            withAnimation { selectedTab += 1 }
                        }
                    } label: {
                        Text("Continue")
                            .foregroundStyle(.teal)
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 48)
                    }
                }
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .tag(1)
                
                SwiftUIView(model: model, opacity: $opacity)
                    .tag(2)
                
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
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
