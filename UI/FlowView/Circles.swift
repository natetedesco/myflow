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
                
                // Flow Circle
                Circle()
                    .trim(from: 0, to: flowCircleFill)
                    .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 5,lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: flowCircleFill)
                    .stroke(Color.myBlue.opacity(0.1),style: StrokeStyle(lineWidth: 8,lineCap: .round))
                    .blur(radius: 10)
                
                Circle()
                    .stroke(Color.myBlue.opacity(0.3),style: StrokeStyle(lineWidth: 4,lineCap: .round))
                    .blur(radius: 0.5)
            }
            else {
                
                // Break Circle
                Circle()
                    .trim(from: 0, to: breakCircleFIll)
                    .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                
                Circle()
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .blur(radius: 0.5)
            }
        }
        .animation(.default.speed(0.2), value: [model.flowTimeLeft, model.breakTimeLeft])
        .rotationEffect(.degrees(-90))
        .frame(width: 310)
    }
    
    var showFlowCircle: Bool {
        if model.mode != .breakRunning && model.mode != .breakStart {
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


