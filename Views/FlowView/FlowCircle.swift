//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 10/17/21.
//

import SwiftUI

struct FlowCircle: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        ZStack {
            // Stroke
            Circle()
                .trim(
                    from: 0,
                    to: model.mode == .Initial || model.mode == .flowStart ? 1.0 :
                        0.0 + formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft)
                )
                .stroke(Color.myBlue,
                        style: StrokeStyle(lineWidth: 8,lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.default.speed(0.20), value: model.animate)
                .frame(width: 310)
            
            // Track
            Circle()
                .stroke(Color.myBlue.opacity(0.3),style: StrokeStyle(lineWidth: 8,lineCap: .round))
                .frame(width: 310)
                .blur(radius: 0.5)
            
            // Glow
            Circle()
                .trim(
                    from: 0,
                    to: model.mode == .Initial || model.mode == .flowStart ? 1.0 :
                        0.0 + formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft)
                )
                .stroke(Color.myBlue.opacity(0.2),style: StrokeStyle(lineWidth: 8,lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.default.speed(0.20), value: model.animate)
                .frame(width: 310)
                .blur(radius: 20.0)
        }
    }
}
