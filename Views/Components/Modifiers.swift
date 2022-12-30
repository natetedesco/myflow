//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

extension View {
    func buttonGlass() -> some View {
        self.modifier(ButtonGlassViewModifier())
    }
    func smallButtonGlass() -> some View {
        self.modifier(SmallButtonGlassViewModifier())
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
}

struct NavigationViewModifier: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
        .padding(.bottom, 85)
        .background(AnimatedBlur())
        .navigationTitle(title)
    }
}

struct ButtonGlassViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
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
            .background(.black.opacity(0.7))
            .background(.ultraThinMaterial.opacity(0.8))
            .cornerRadius(20.0)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 0.2)
                )
            .padding(.horizontal)
    }
}

struct CardGlassNPViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .background(.black.opacity(0.7))
            .background(.ultraThinMaterial.opacity(0.3))
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}


