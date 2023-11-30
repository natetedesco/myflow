//
//  Glass Components.swift
//  MyFlow
//  Created by Nate Tedesco on 8/30/23.
//

import SwiftUI

struct CustomHeadline: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .fontWeight(.light)
            .padding(.leading, 32)
            .padding(.top)
            .leading()
    }
}


struct MaterialBackGround: View {
    var body: some View {
        Color.clear.opacity(0.0).ignoresSafeArea()
            .background(.ultraThinMaterial)
    }
}

extension View {
    
    func smallButtonGlass() -> some View {
        self
//            .foregroundColor(.myColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.bar)
            .cornerRadius(30)
    }
    
    func CircularGlassButton(padding: Double = 12) -> some View {
        self
            .font(.title3)
            .padding(padding)
            .background(Circle()
                .fill(.ultraThinMaterial)
            )
    }
    
    func cardGlass() -> some View {
        self
            .maxWidth()
            .padding(.vertical)
            .background(.black.opacity(0.0))
            .background(.ultraThinMaterial)
            .cornerRadius(20.0)
            .padding(.horizontal)
    }
    
    func cardGlassNP() -> some View {
        self
            .padding(.vertical, 12)
            .background(.black.opacity(0.0))
            .background(.regularMaterial)
            .cornerRadius(20)
            .padding(.horizontal)
    }
}
