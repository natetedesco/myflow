//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

extension View {
    
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
    
    func trailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func top() -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .top)
    }
}

// Corner for top only - picker
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
