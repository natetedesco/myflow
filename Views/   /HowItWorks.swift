//
//  HowItWorks.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct HowItWorks: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 64) {
            HStack {
                Image(systemName: "circle")
                    .myBlue()
                    .font(.largeTitle)
                    .padding(.trailing, 4)
                    .background(Circle()
                        .fill(.ultraThinMaterial.opacity(0.55)))
                
                VStack {
                    Text("Create Flows")
                        .font(.headline)
                        .leading()
                    Text("Using time blocks or intervals")
                        .leading()
                        .font(.footnote)
                }
            }
            .leading()
            
            HStack {
                Image(systemName: "chart.bar")
                    .myBlue()
                    .CircularGlassButton()
                    .padding(.leading, -4) // no idea
                VStack {
                    Text("Visualize progress")
                        .font(.headline)
                        .leading()
                    Text("Using time blocks or intervals")
                        .font(.footnote)
                        .leading()
                }
            }
            .leading()
            
            HStack {
                Image(systemName: "bell")
                    .myBlue()
                    .CircularGlassButton()
                VStack {
                    Text("Allow Notifications")
                        .leading()
                        .font(.headline)
                    Text("Required for app functionality")
                        .leading()
                        .font(.footnote)
                }
            }
            .leading()
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(AnimatedBlur(opacity: 0.01))
    }
}

struct HowItWorks_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorks()
    }
}
