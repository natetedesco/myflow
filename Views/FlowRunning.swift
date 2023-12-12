//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/12/23.
//

import SwiftUI

struct FlowRunning: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Button {
                    model.showFlowRunning.toggle()
                } label: {
                    Capsule()
                        .foregroundStyle(.white.quinary)
                        .frame(width: 36, height: 5)
                        .padding(.top, sizeClass == .regular ? 16 : 0)
                }
                
                Spacer()
                
                Text(focusLabel)
                    .font(sizeClass == .regular ? .largeTitle : .title)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
                Spacer()
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        if model.mode == .flowStart {
                            Text("Next: " + model.flow.blocks[model.blocksCompleted].title)
                                .fontWeight(.medium)
                                .foregroundStyle(.teal.secondary)
                                .padding(.bottom, 48)
                        }
                    }
                    
                    Circles(
                        model: model,
                        size: sizeClass == .regular ? 432: 288,
                        width: sizeClass == .regular ? 30 : 20)
                    
                    Button { // used twice
                        if model.mode == .flowStart {
                            model.extend()
                        } else if model.flowExtended {
                            model.completeExtend()
                        } else {
                            model.Complete()
                        }
                        softHaptic()
                    } label: {
                        HStack {
                            if !model.flowExtended {
                                Image(systemName: model.mode == .flowStart ? "goforward.plus" :"checkmark.circle")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .padding(.trailing, -4)
                            }
                            Text(model.mode == .flowStart ? "Extend" : "Complete")
                        }
                        .font(.footnote)
                        .fontWeight(.medium)
                    }
                    .padding(.top, 112)
                    
                    ZStack {
                        Text(timerLabel)
                            .font(.system(size: 72))
                            .fontWeight(.light)
                            .monospacedDigit()
                        
                        if model.flowExtended {
                            Image(systemName: "plus")
                                .font(.title3)
                                .padding(.trailing, 216)
                        }
                        
//                        Text(focusLabel)
//                            .font(.title3)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.secondary)
//                            .padding(.bottom, 112)
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
        if model.mode == .flowStart {
            return model.flow.blocks[model.blocksCompleted - 1].title
        }
        return model.flow.blocks[model.blocksCompleted].title
    }
    
    var timerLabel: String {
        if model.mode == .flowStart {
            return "00:00"
        }
        return formatTime(seconds: model.flowTimeLeft)
    }
    
}

import SwiftUI

struct Circles: View {
    var model: FlowModel
    var size: CGFloat = 288
    var width: CGFloat = 20
    var fill: Bool = false
    
    var body: some View {
        ZStack {
            
            // Ring
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(Color.teal, style: StrokeStyle(lineWidth: width,lineCap: .round))
//                .shadow(color: .teal.opacity(0.5), radius: 5)
                .frame(width: size)
            
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(Color.teal.opacity(0.5), style: StrokeStyle(lineWidth: width,lineCap: .round))
                .blur(radius: 5)
                .frame(width: size)
            
            
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
            else if model.mode == .flowStart {
                return 1.0
            }
            
            else if model.flowExtended {
                return 1.0
            }
            
            // Flow Running
            else if model.mode == .flowRunning {
                if model.flowExtended {
                    return 1.0
                } else {
                    return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
                }
            }
            
            else if model.flowTime - model.flowTimeLeft == 0 {
                return 0
            }
            return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
        }
    }
}




//#Preview {
//    FlowRunning()
//}
