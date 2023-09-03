//
//  Backgrounds.swift
//  MyFlow
//
//  Created by Nate Tedesco on 8/30/23.
//

//e9e2eda617c506ff21633f8bed64420e
//papers.co-vs13-blue-paint-rainbow-art-pattern-41-iphone-wallpaper

import SwiftUI

extension View {
    
        func FlowViewBackGround() -> some View {
            let theme = AppSettings.shared.theme

            return self
                .background(AnimatedBlur(opacity: theme == "default" ? 1.0 : 0.0))
                .background(Image(theme).resizable().ignoresSafeArea().opacity(theme == "default" ? 0.0 : 1.0))
        }
        
        func navigationView(title: String, button: some View = EmptyView()) -> some View {
            let theme = AppSettings.shared.theme

            return NavigationView {
            self
                .padding(.bottom, 68)
                .background(AnimatedBlur(opacity: theme == "default" ? 1.0 : 0.0))
                .background(Image(theme).resizable().ignoresSafeArea().opacity(theme == "default" ? 0.0 : 1.0))
                .navigationTitle(title)
                .toolbar{ button }
                .accentColor(.myColor)
            }
            .navigationViewStyle(StackNavigationViewStyle()) // I think for ipad
        }
    
    
    func previewBackGround() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.6))
                .background(.ultraThinMaterial)
                .background(AnimatedBlur(opacity: 1.0))
    }
}
