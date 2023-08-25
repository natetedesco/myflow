//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 10/17/21.
//

import SwiftUI

struct Circles: View {
    @ObservedObject var model: FlowModel
    
    // Body
    var body: some View {
        ZStack {
            if showFlowCircle {
                
                Circle()
                    .fill(.ultraThinMaterial)
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.black.opacity(0.5), .black.opacity(0.7)]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 320
                        )
                    )
                
                if model.mode != .Initial {
                    // Flow Circle
                    Circle()
                        .trim(from: 0, to: flowCircleFill)
                        .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 6,lineCap: .round))
                        .frame(width: 314)
                    
                    Circle()
                        .trim(from: 0, to: flowCircleFill)
                        .stroke(Color.black.opacity(0.1),style: StrokeStyle(lineWidth: 6,lineCap: .round))
                        .blur(radius: 10)
                        .frame(width: 314)
                }
            }
            else {
                
                // Break Circle
                Circle()
                    .trim(from: 0, to: breakCircleFIll)
                    .stroke(Color.white.opacity(0.8), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                
                Circle()
                    .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .blur(radius: 0.5)
            }
        }
        .animation(.none, value: showFlowCircle)
        .animation(.default.speed(0.2), value: [model.flowTimeLeft, model.breakTimeLeft])
        .rotationEffect(.degrees(-90))
        .frame(width: 320)
    }
    
    var showFlowCircle: Bool {
        if model.mode != .breakRunning && model.mode != .breakPaused {
            return true
        }
        return false
    }
    
    var flowCircleFill: CGFloat {
        if model.mode == .Initial {
            return 1.0
        }
        if model.mode == .flowStart {
            return 0.0
        }
        if model.flowContinue {
            return 1.0
        }
        if model.flowTime - model.flowTimeLeft == 0 {
            return 0
        }
        return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
    }
    
    var breakCircleFIll: CGFloat {
        if model.mode == .Initial {
            return 1.0
        }
        if model.mode == .breakStart {
            return 0.0
        }
        if model.breakTime - model.breakTimeLeft == 0 {
            return 0
        }
        return formatProgress(time: model.breakTime, timeLeft: model.breakTimeLeft - 1)
    }
}


