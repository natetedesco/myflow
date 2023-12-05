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

                
//                Text(model.flow.title)
                Text(focusLabel)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
//                Text(model.flow.blocks[model.blocksCompleted].title)
//                    .font(.title3)
//                    .fontWeight(.medium)
//                    .foregroundStyle(.secondary)
                
                Spacer()
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        if model.mode == .flowStart {
                            Text("Next: " + model.flow.blocks[model.blocksCompleted].title)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.teal.secondary)
                                .padding(.bottom, 48)
                            
                        }
                    }
                    
                    Circles(model: model)
                    ZStack {
                        Button {
                            if model.mode == .flowStart {
                                model.continueFlow()
                            } else {
                                model.Skip()
                            }
                            softHaptic()
                        } label: {
                            HStack {
                                Image(systemName: model.mode == .flowStart ? "goforward.plus" :"goforward")
                                Text(model.mode == .flowStart ? "Extend" : "Complete")
                            }
                            .font(.callout)
                            .fontWeight(.medium)
                        }
                        .padding(.bottom, 112)

                        Text(formatTime(seconds: model.flowTimeLeft))
                            .font(.system(size: 72))
                            .fontWeight(.thin)
                            .monospacedDigit()
                        
                        if model.flowContinue {
                            Image(systemName: "plus")
                                .font(.title3)
                                .padding(.top, 112)
                        }
                        
                    }
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
            .toolbar {}
        }
    }
    
    var focusLabel: String {
        if model.mode == .flowStart || model.flowContinue {
            return model.flow.blocks[model.blocksCompleted - 1].title
        }
        return model.flow.blocks[model.blocksCompleted].title
    }
    
}

import SwiftUI

struct Circles: View {
    var model: FlowModel
    var size: CGFloat = 288
    var width: CGFloat = 18
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
