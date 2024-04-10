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
    
    @State var selectedTab = 1
    @State var showBlur = true
    @State var opacity = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBlur(offset: false, opacity: 0.6)
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    Text("Experience")
                        .padding(.top, 48)
                    Text("Flow")
                        .foregroundStyle(.teal)
                }
                .fontWeight(.bold)
                .font(.system(size: 48))
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
                        
                        Text("A flexible block of time for deep, uninterupted focus.")
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
                        Text("Recharge your attention after a focus block or continue to flow.")
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
//                .padding(.bottom)
                
                Spacer()
                
                Button {
                    withAnimation { opacity = 0 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showOnboarding = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        if !proAccess {
                            model.showPayWall(large: false)
                        }
                    }
//                    softHaptic()
                } label: {
                    Text("Continue")
                        .foregroundStyle(.teal)
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.teal)
//                        .cornerRadius(24)
                        .padding(.leading, 48)
                        .padding(.trailing, 40)
                        .padding(.bottom)
                }
            }
            
            .padding(.bottom, 8)
            .padding(.leading, 32)
            .padding(.trailing, 40)
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
