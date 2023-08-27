//
//  Title.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

extension Color {
    static func rgb(r: Double, g: Double, b: Double ) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    static let darkBackground = Color(#colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.08235294118, alpha: 1))
    static let myBlue = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
}

struct CustomHeadline: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .fontWeight(.semibold)
            .padding(.leading)
            .padding(.top)
            .leading()
    }
}

struct Chevron: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .font(Font.system(size: 20))
            .padding(.horizontal, 4)
    }
}

struct MaterialBackGround: View {
    var body: some View {
        Toolbar(model: FlowModel())
        Color.clear.opacity(0.0).ignoresSafeArea()
            .background(.ultraThinMaterial)
    }
}
