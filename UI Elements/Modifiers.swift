//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

extension View {
    
    func sheetMaterial() -> some View {
        self
            .presentationCornerRadius(40)
            .presentationBackground(.bar)
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
    
    func trailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func top() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func darken(amount: CGFloat) -> some View {
        ZStack {
            Color.black.opacity(amount)
                .ignoresSafeArea()
            self
        }
    }
}
