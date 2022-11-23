//
//  Title.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct BackGround: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.darkBackground, Color.darkBackground]), startPoint:
                        .topTrailing, endPoint: .center).edgesIgnoringSafeArea(.all)
    }
}

struct Title_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatedBlur()
        }
    }
}
