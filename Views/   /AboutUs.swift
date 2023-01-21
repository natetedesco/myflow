//
//  AboutUs.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        VStack() {
            VStack(spacing: 8) {
                Image("Image")
                    .padding(.bottom)
                
                Text("MyFlow")
                    .myBlue()
                    .font(.largeTitle)
                    .fontWeight(.ultraLight)
                    .kerning(3.0)
                
                Text("Focus on what matters.")
                    .font(.footnote)
                
                FootNote(text: "2.0")
            }
            .padding(.bottom, 32)
            
            Text("How can we make better use of our time? In a world full of distractions how can we create an environment to just focus? Focus on the things that really matter. Because we owe that to ourselves. We deserve to realize our dreams and stay true to our passions. Motivation fuels us but consistency moves us forward. That is the idea that created MyFlow.")
                .fontWeight(.light)
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(AnimatedBlur(opacity: 0.01))
    }
}


struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
