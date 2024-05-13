//
//  AboutView.swift
//  MyFlow
//
//  Created by Developer on 5/5/24.
//

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                Circles(model: FlowModel(), size: 112, width: 12.0, fill: true)
                
                VStack(spacing: 8) {
                    Text("MyFlow")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Focus on what matters")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("MyFlow optimizes your time by enhancing your focus. Giving your complete focus to a task, and alloting a specific amount of time to it, allows you to complete things faster and with less distraction.")
                    
                    Text("Your feedback and support is greatly appreciated and continues to drive the development of MyFlow.")
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                
                Text("Developed by Nate Tedesco")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
                
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AboutView()
}
