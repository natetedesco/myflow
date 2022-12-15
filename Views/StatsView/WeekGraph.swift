//
//  Components.swift
//  MyFlow
//  Created by Nate Tedesco on 6/14/22.
//

import SwiftUI

struct BarGraph: View {
    var text: String = "D"
    var color: Color = .gray
    var value: CGFloat
    
    var body: some View {
        VStack {
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(width: 25, height: 60)
                        .foregroundColor(.myBlue.opacity(0.1))
                    
                    Rectangle().frame(width: 25, height: min(CGFloat(self.value)*60, 80))
                        .foregroundColor(.myBlue)
                }
                .cornerRadius(25)
            
            Text(text)
                .foregroundColor(color)
                .font(.footnote)
        }
    }
}



