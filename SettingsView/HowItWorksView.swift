//
//  How It Works.swift
//  MyFlow
//
//  Created by Developer on 5/5/24.
//

import SwiftUI

struct HowItWorks: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("Create your")
                Text("Flow")
                    .foregroundStyle(.teal)
            }
            .font(.system(size: 44))
            .fontWeight(.bold)
            .padding(.top, -32)
            .padding(.bottom, 40)
            
            HStack(alignment: .top) {
                Image(systemName: "rectangle.stack")
                    .foregroundStyle(.teal)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text("Focus Blocks")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Setting a time for each block promotes deeper focus. Blocks can be complete early or extended.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                Image(systemName: "timer")
                    .foregroundStyle(.teal)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text("Take Breaks")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Breaks can help us stay in a flow, choose to take a break at the end of a focus or start the next focus.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                Image(systemName: "shield")
                    .foregroundStyle(.teal)
                    .fontWeight(.medium)
                    .font(.largeTitle)
                    .padding(.top, 4)
                
                VStack(alignment: .leading) {
                    Text("Block Distractions")
                        .font(.title3)
                    
                        .fontWeight(.bold)
                    
                    Text("Block Apps you don't want to disturb you or use during your flow.")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

#Preview {
    HowItWorks()
}
