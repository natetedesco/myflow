//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
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

extension View {
    func cardGlassNP() -> some View {
        self
            .padding(.vertical, 12)
            .background(.black.opacity(0.0))
            .background(.regularMaterial)
            .cornerRadius(20)
            .padding(.horizontal)
    }
}

extension View {
    
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
}
