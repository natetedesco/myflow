//
//  AboutUs.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        NavigationView {
            
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
            }
            .padding(.bottom, 16)
            
            Text("In a world full of distractions how can we create an environment to focus on the things that really matter. Because we owe that to ourselves. That is the idea that created MyFlow.")
                .fontWeight(.light)
                .padding(.bottom)
            
            VStack(alignment: .leading){
                
            Link("Privacy Policy", destination: URL(string: "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4")!)
                .padding(.bottom)
                .foregroundColor(.myBlue)
            
            Link("Terms Of Use", destination: URL(string: "https://myflow.notion.site/Terms-Of-Use-50feabde93874a54b823a6627e0fa5ca?pvs=4")!)
                .padding(.bottom)
                .foregroundColor(.myBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()

            
        }
        .padding(.horizontal, 32)
        .background(AnimatedBlur(opacity: 0.01))
        }
    }
}


struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
