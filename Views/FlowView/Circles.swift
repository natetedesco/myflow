//
//  FlowCircle.swift
//  MyFlow
//  Created by Nate Tedesco on 10/17/21.
//

import SwiftUI

struct Circles: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        ZStack {
            
            // Background
            Circle()
                .fill(.ultraThinMaterial)
            Circle()
                .fill(RadialGradient(
                    gradient: Gradient(
                        colors: [.black.opacity(0.5), .black.opacity(0.7)]),
                    center: .center, startRadius: 10, endRadius: 320))
            
            // Ring
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(showFlowCircle ? Color.myBlue : Color.gray,
                        style: StrokeStyle(lineWidth: 8,lineCap: .round))
                .frame(width: 312)
            
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(showFlowCircle ? Color.myBlue : Color.gray,
                        style: StrokeStyle(lineWidth: 8,lineCap: .round))
                .opacity(0.3)
                .blur(radius: 10)
                .frame(width: 312)
            
        }
        .animation(.none, value: showFlowCircle)
        .animation(.default.speed(0.3), value: [model.flowTimeLeft, model.breakTimeLeft])
        .rotationEffect(.degrees(-90))
        .frame(width: 320)
    }
    
    var showFlowCircle: Bool {
        if model.mode == .flowStart || model.mode == .breakRunning {
            return false
        }
        return true
    }
    
    var circleFill: CGFloat {
        
        // Initial
        if model.mode == .Initial {
            return 0
        }
            
        // Flow Start
        if model.mode == .flowStart {
            return 0
        }
        
        // Break Start
        if model.mode == .breakStart {
            return 1.0
        }
        
        // Flow Running
        if model.mode == .flowRunning {
            if model.flowContinue {
                return 1.0
            } else {
                return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
            }
        }
        
        // Break Running
        if model.mode == .breakRunning {
            return formatProgress(time: model.breakTime, timeLeft: model.breakTimeLeft - 1)
        }

        if model.flowTime - model.flowTimeLeft == 0 {
            return 0
        }
        return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
    }
}


