//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

extension View {
    func buttonGlass() -> some View {
        self
            .myBlue()
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial.opacity(0.55))
            .cornerRadius(30)
    }
    
    func smallButtonGlass() -> some View {
        self
            .myBlue()
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial.opacity(0.55))
            .cornerRadius(30)
    }
    
    func CircularGlassButton() -> some View {
        self
            .font(.title3)
            .padding(12)
            .background(Circle()
                .fill(.ultraThinMaterial.opacity(0.55)))
    }
    
    func customGlass() -> some View {
        self
            .maxWidth()
            .padding(24)
            .background(.black.opacity(0.7))
            .cornerRadius(40)
            .padding(.horizontal, 32)
    }
    
    func cardGlass() -> some View {
        self
            .maxWidth()
            .padding()
            .background(.black.opacity(0.6))
            .cornerRadius(25.0)
            .padding(.horizontal)
    }
    
    func cardGlassNP() -> some View {
        self
            .padding(.vertical)
            .background(.black.opacity(0.6))
            .cornerRadius(25.0)
            .padding(.horizontal)
    }
    
    func FlowViewBackGround() -> some View {
        self
            .background(.black.opacity(0.8))
            .background(.ultraThinMaterial)
            .background(AnimatedBlur(opacity: 0.3))
    }
    
    func navigationView(title: String, button: some View = EmptyView()) -> some View {
        NavigationView {
        self
            .padding(.bottom, 85)
            .background(.black.opacity(0.6))
            .background(.ultraThinMaterial)
            .background(AnimatedBlur(opacity: 0.3))
            .navigationTitle(title)
            .toolbar{ button }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.myBlue)
    }
    
    func previewBackGround() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.6))
                .background(.ultraThinMaterial)
                .background(AnimatedBlur(opacity: 0.3))
    }
    
    func myBlue() -> some View {
        self
            .foregroundColor(.myBlue)
    }
    
    func gray() -> some View {
        self
            .foregroundColor(.gray)
    }
    
    func maxWidth() -> some View {
        self
            .frame(maxWidth: .infinity)
    }
    
    func centered() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func leading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func top() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
}
