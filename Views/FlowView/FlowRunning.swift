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
                    
                    Button {
                        model.Skip()
                        softHaptic()
                    } label: {
                        Text("Complete")
                            .foregroundColor(.myColor)
                            .font(.footnote)  
                    }
                    .padding(.top, 120)
                    
                    Text(model.flow.blocks[model.blocksCompleted].title)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, 128)
                }
                
                Spacer()
                
                Button {
                    model.Start()
                    softHaptic()
                } label: {
//                    Text(model.mode == .flowRunning ? "Pause" : "Start")
                    Image(systemName: model.mode == .flowRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundStyle(.teal)
                        .padding(20)
                        .background(Circle().foregroundStyle(.teal.quinary))
                }
                
                
                
                
            }
            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//                    HStack {
//                        
//                        
//                        Button {
//                            model.showFlowRunning.toggle()
//                        } label: {
//                            Image(systemName: "gobackward")
//                                .foregroundStyle(.teal)
//                        }
//
//                        
//                        Spacer()
//                        
//                        
//
//                        
//
//                    }
//                    
//                }
            }
        }
        
        
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
