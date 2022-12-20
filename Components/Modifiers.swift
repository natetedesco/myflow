//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct CustomGlass: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.black.opacity(0.7))
            .background(.regularMaterial)
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}

struct CustomGlassNoHPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical)
            .background(.black.opacity(0.7))
            .background(.regularMaterial)
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}

struct CustomSheet: ViewModifier {
    @ObservedObject var model: FlowModel
    @Binding var selectedFlow: Flow?
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $selectedFlow) { flow in
                FlowSheet(flowModel: model, flow: flow)
                    .background(.black.opacity(0.3))
                    .clearModalBackground()
                    .background(.ultraThinMaterial)
                    .presentationDetents([.large])
                    .preferredColorScheme(.dark)
            }
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
