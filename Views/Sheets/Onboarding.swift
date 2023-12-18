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
    
    @State var showBlur = true
    
    var body: some View {
        ZStack {
            AnimatedBlur(opacity: showBlur ? 0.3 : 0.0)
            
            VStack(spacing: 16) {
                Spacer()
                
                Circles(model: FlowModel(), size: 160, width: 16.0, fill: true)
                
                Text("Experience Flow")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
                Text("Focus on what matters.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 64)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    showOnboarding = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        if !proAccess {
                            showIntro = true
                        }
                    }
                    softHaptic()
                } label: {
                    Text("Let's Flow")
                        .font(.title3)
                        .foregroundStyle(.teal)
                }
                .padding(.bottom)
            }
//            .opacity(showOnboarding ? 1.0 : 0.0)
            .animation(.easeOut, value: showOnboarding)
        }
        .background(Color.black)
//        .opacity(showOnboarding ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 2.0), value: showOnboarding)
    }
}

#Preview {
    OnboardingView()
}
