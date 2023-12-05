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

    @State var showBlur = true
    
    var body: some View {
        ZStack {
            AnimatedBlur(opacity: showBlur ? 0.5 : 0.0)
                .animation(.default.speed(2.0), value: showBlur)
            
            VStack {
                Spacer()
                
                Circles(model: FlowModel(), size: 160, width: 16.0, fill: true)
                
                Spacer()
                
                Text("Experience Flow")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(2)
                Text("In a world of distractions, focus on what truly matters.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 64)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
//                    detent = .fraction(6/10)
                    
                        showOnboarding = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        showIntro = true
                    }
                    softHaptic()
                } label: {
                    Text("Let's Flow")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.8)]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .padding(.bottom)
                }
            }
            .opacity(showOnboarding ? 1.0 : 0.0)
            .animation(.easeOut, value: showOnboarding)
        }
        .background(Color.black)
        .opacity(showOnboarding ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 2.0), value: showOnboarding)
    }
}

#Preview {
    OnboardingView()
}
