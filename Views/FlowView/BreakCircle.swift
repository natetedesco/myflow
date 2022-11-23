//
//  BreakCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 10/17/21.
//

import SwiftUI

struct BreakCircle: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        ZStack {
            // Stroke
            Circle()
                .trim(
                    from: 0,
                    to: model.mode == .Initial || model.mode == .flowStart ? 1.0 :
                        0.0 + formatProgress(time: model.breakTime, timeLeft: model.breakTimeLeft)
                )
//                .stroke(Color.darkGray,
                .stroke(Color.gray.opacity(0.3),
                        
                        style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.default.speed(0.20), value: model.animate)
                .frame(width: 260)
            
            // Track
            Circle()
                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .frame(width: 260)
                .blur(radius: 0.5)
        }
    }
}
