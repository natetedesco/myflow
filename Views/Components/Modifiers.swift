//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct ButtonGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial.opacity(0.55))
        .cornerRadius(30)
    }
}

struct SmallButtonGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
        .foregroundColor(.myBlue)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial.opacity(0.55))
        .cornerRadius(30)
    }
}

struct CustomGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(.black.opacity(0.7))
//            .background(.thinMaterial)
            .cornerRadius(40)
            .padding(.horizontal, 32)
    }
}

struct CardGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(.black.opacity(0.7))
            .background(.ultraThinMaterial.opacity(0.8))
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}

struct CardGlassNP: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .background(.black.opacity(0.7))
            .background(.ultraThinMaterial.opacity(0.3))
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground() -> some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}
