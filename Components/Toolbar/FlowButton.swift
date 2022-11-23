//
//  FlowButton.swift
//  MyFlow
//  Created by Nate Tedesco on 6/9/22.
//

import SwiftUI

struct FlowButton: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(.myBlue)
                .frame(width: 90, height: 50)
            Circle()
                .stroke(Color.gray.opacity(0.5),style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 90, height: 35)
        }
    }
}

struct FlowButton_Previews: PreviewProvider {
    static var previews: some View {
        FlowButton()
    }
}
