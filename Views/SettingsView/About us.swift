//
//  About us.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        ZStack {
            AnimatedBlurOpaque()
            VStack(spacing: 8) {
                Image("Image")
                    .padding(.bottom, 8)
                
                Text("MyFlow")
                    .font(.title)
                    .fontWeight(.bold)
                    
                Text("Encouraging a flow state of mind.")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("v2.0")
                    
                Spacer()
            }
        }
        
    }
}

struct HowItWorks: View {
    var body: some View {
        Text("How it works")
    }
}
