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

struct Title: View {
    var text: String
    var body: some View {
        ZStack {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.light)
                .kerning(5.0)
                .foregroundColor(.myBlue)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct Headline: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.leading)
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BackGround: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.darkBackground, Color.darkBackground]), startPoint:
                        .topTrailing, endPoint: .center).edgesIgnoringSafeArea(.all)
    }
}

