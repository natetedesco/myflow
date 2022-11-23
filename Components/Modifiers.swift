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
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}

struct CustomGlassNoPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.black.opacity(0.7))
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
}
