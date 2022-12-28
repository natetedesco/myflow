//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 10/17/21.
//

import SwiftUI

struct Circles: View {
    @ObservedObject var model: FlowModel
    
    var FlowCircle: some View {
        ZStack {
            
            // Stroke
            Circle()
                .trim(from: 0, to: flowCircleFill)
                .stroke(Color.myBlue,
                        style: StrokeStyle(lineWidth: 5,lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.default.speed(0.20), value: model.animate)
                .frame(width: 310)
            
            // Track
            Circle()
                .stroke(Color.myBlue.opacity(0.35),style: StrokeStyle(lineWidth: 4,lineCap: .round))
                .frame(width: 310)
                .blur(radius: 0.5)
            
            // Glow
                Circle()
                    .trim(from: 0, to: flowCircleFill)
                    .stroke(Color.myBlue.opacity(0.1),style: StrokeStyle(lineWidth: 8,lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.default.speed(0.20), value: model.animate)
                    .frame(width: 310)
                .blur(radius: 10)
            
            
        }
    }
    
    var BreakCircle: some View {
        ZStack {
            // Stroke
            Circle()
                .trim(from: 0, to: breakCircleFIll)
                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.default.speed(0.20), value: model.animate)
                .frame(width: 310)
            
            // Track
            Circle()
                .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 310)
                .blur(radius: 0.5)
        }
    }
    
    // Body
    var body: some View {
        
        if (model.flowMode == .Custom && model.type == .Flow) ||
            (model.flowMode == .Simple && (model.mode != .breakRunning && model.mode != .flowStart)) {
            FlowCircle
        }
        else {
            BreakCircle
        }
    }
    
    var flowCircleFill: CGFloat {
        if model.mode == .Initial || model.mode == .flowStart {
            return 1.0
        }
        if model.flowContinue {
            return 1.0
        }
        if model.mode == .breakStart {
            return 1.0
        }
        return 0.0 + formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft)
    }
    
    var breakCircleFIll: CGFloat {
        if model.mode == .Initial || model.mode == .flowStart {
            return 1.0
        }
        return 0.0 + formatProgress(time: model.breakTime, timeLeft: model.breakTimeLeft)
    }
}


