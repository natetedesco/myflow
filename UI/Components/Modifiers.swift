//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct FlowViewBackGroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.black.opacity(0.8))
            .background(.ultraThinMaterial)
            .background(AnimatedBlur(opacity: 0.3))
    }
}

struct NavigationViewModifier: ViewModifier {
    var title: String
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 85)
            .background(.black.opacity(0.6))
            .background(.ultraThinMaterial)
            .background(AnimatedBlur(opacity: 0.3))
            .navigationTitle(title)
    }
}

struct CircularGlassButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .padding(12)
            .background(Circle()
                .fill(.ultraThinMaterial.opacity(0.55)))
    }
}

struct ButtonGlassViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.myBlue)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial.opacity(0.55))
            .cornerRadius(30)
    }
}

struct SmallButtonGlassViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.myBlue)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial.opacity(0.55))
            .cornerRadius(30)
    }
}

struct CustomGlassViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(.black.opacity(0.7))
            .cornerRadius(40)
            .padding(.horizontal, 32)
    }
}

struct CardGlassViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black.opacity(0.6))
            .cornerRadius(25.0)
            .padding(.horizontal)
    }
}

struct CardGlassNPViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .background(.black.opacity(0.6))
            .cornerRadius(25.0)
            .padding(.horizontal)
    }
}

extension View {
    func buttonGlass() -> some View {
        self.modifier(ButtonGlassViewModifier())
    }
    func smallButtonGlass() -> some View {
        self.modifier(SmallButtonGlassViewModifier())
    }
    func CircularGlassButton() -> some View {
        self.modifier(CircularGlassButtonViewModifier())
    }
    
    func customGlass() -> some View {
        self.modifier(CustomGlassViewModifier())
    }
    func cardGlass() -> some View {
        self.modifier(CardGlassViewModifier())
    }
    func cardGlassNP() -> some View {
        self.modifier(CardGlassNPViewModifier())
    }
    
    func settingsNavigationView() -> some View {
        self.modifier(NavigationViewModifier(title: "Settings"))
    }
    func statisticsNavigationView() -> some View {
        self.modifier(NavigationViewModifier(title: "Statistics"))
    }
    
    func FlowViewBackGround() -> some View {
        self.modifier(FlowViewBackGroundModifier())
    }
}
