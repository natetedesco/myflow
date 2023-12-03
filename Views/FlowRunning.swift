//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/12/23.
//

import SwiftUI

struct FlowRunning: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Button {
                    model.showFlowRunning.toggle()
                } label: {
                    Capsule()
                        .foregroundStyle(.white.quinary)
                        .frame(width: 36, height: 5)
                }
                
                Text(model.flowList[model.selection].title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top)
                
                Spacer()
                
                ZStack {
                    Circles(model: model)
                    Text(formatTime(seconds: model.flowTimeLeft))
                        .font(.system(size: 72))
                        .fontWeight(.thin)
                        .monospacedDigit()
                    
                    Text(model.flow.blocks[model.blocksCompleted].title)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, 128)
                }
                
                Spacer()
                
                Button {
                    model.Skip()
                    softHaptic()
                } label: {
                    Text("Complete")
                    
                        .font(.callout)
                }
                
                Spacer()
                
                Button {
                    model.Start()
                    softHaptic()
                } label: {
                    Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .padding(20)
                        .background(Circle().foregroundStyle(.teal.quinary))
                }
                
                
            }
            .accentColor(.teal)
            .toolbar {}
        }
    }
}

import SwiftUI

struct Circles: View {
    var model: FlowModel
    var size: CGFloat = 272
    var width: CGFloat = 24
    var fill: Bool = false
    
    var body: some View {
        ZStack {
            
            // Ring
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(Color.teal, style: StrokeStyle(lineWidth: width,lineCap: .round))
                .frame(width: size)
                .shadow(color: .teal.opacity(0.5), radius: 5)
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.teal.opacity(0.2), style: StrokeStyle(lineWidth: width,lineCap: .round))
                .frame(width: size)
        }
        .rotationEffect(.degrees(-90))
        .frame(width: size)
        .animation(.default, value: circleFill)
    }
    
    
    var circleFill: CGFloat {
        if fill {
            return 1.0
        } else {
            
            // Initial
            if model.mode == .initial {
                return 0
            }
            
            // Flow Start
            if model.mode == .flowStart {
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
            
            if model.flowTime - model.flowTimeLeft == 0 {
                return 0
            }
            return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
        }
    }
}




//#Preview {
//    FlowRunning()
//}
