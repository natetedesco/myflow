//
//  Flow.swift
//  MyFlow
//
//  Created by Nate Tedesco on 9/12/23.
//

import SwiftUI

struct FlowRunning: View {
    @State var model: FlowModel
    @Binding var detent: PresentationDetent
    @State var showResetAlert = false

    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
            NavigationView {
                    ZStack {
//                        Color.black.opacity(detent == .large ? 0.3 : 0.0).ignoresSafeArea()
//                        AnimatedBlur(opacity: 0.3)
                        
                        if detent == .large {
                            VStack {
                                Text(model.flow.blocks[model.blocksCompleted].title)
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(.top, 32)
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                ZStack {
                                    Circles(model: model)
                                    Text(formatTime(seconds: model.flowTimeLeft))
                                        .font(.system(size: 64))
//                                        .fontWeight(.thin)
                                        .monospacedDigit()
                                }
                                
                                Spacer()
                                
                                if model.mode == .flowPaused {
                                    Button {
                                        model.Reset()
                                    } label: {
                                        HStack {
                                            Text("Reset")
                                            Image(systemName: "gobackward")
                                        }
                                        .foregroundColor(.myColor)
                                    }
                                } else {
                                    Button {
                                        model.Skip()
                                        softHaptic()
                                    } label: {
                                        HStack {
                                            Image(systemName: "checkmark.circle")
                                            Text("Complete")
                                        }
                                        .foregroundColor(.myColor)
                                    }
                                }
                                Spacer()
                            }
                        } else {
                            HStack {
                                
                                Gauge(value: formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft), label: {Text("")})
                                    .gaugeStyle(.accessoryCircularCapacity)
                                    .tint(.myColor)
                                
                                Text(model.flow.blocks[model.blocksCompleted].title)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .leading()
                                    .padding(.leading, 8)
                                
                                Spacer()
                                
                                Text(formatTime(seconds: model.flowTimeLeft))
                                    .font(.headline)
                                    .monospacedDigit()
                                    .trailing()
                            }
                            .padding(.horizontal)
                            .padding(.top)
                        }
                    }
                    
                    .toolbar {
                        
                        ToolbarItem(placement: .bottomBar) {
                            
                            if detent == .large {
                                
                                Button {
                                    model.Start()
                                    softHaptic()
                                } label: {
                                    Text(model.mode == .flowRunning ? "Pause" : "Start")
                                        .foregroundColor(.myColor)
                                        .font(.title2)
                                        .padding(.vertical, 12)
                                        .padding(.horizontal)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                
            }
        .frame(maxWidth: .infinity)
        // Reset Alert
        .confirmationDialog("", isPresented: $showResetAlert) {  // Delete Flow Alert
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                model.Reset()
            }
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
                .stroke(Color.myColor, style: StrokeStyle(lineWidth: width,lineCap: .round))
                .frame(width: size)
                .shadow(color: .myColor.opacity(0.5), radius: 5)
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.myColor.opacity(0.2), style: StrokeStyle(lineWidth: width,lineCap: .round))
                .frame(width: size)
            
//            Circle()
//                .trim(from: 0, to: circleFill)
//                .stroke(Color.myColor.opacity(0.6), style: StrokeStyle(lineWidth: width,lineCap: .round))
//                .opacity(0.1)
//                .blur(radius: 10)
//                .frame(width: size)
            
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
