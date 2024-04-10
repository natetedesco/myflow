//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/12/23.
//

import SwiftUI

struct FlowRunning: View {
    @State var model: FlowModel
    @AppStorage("ProAccess") var proAccess: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    
    var body: some View {
        ZStack {

            VStack {
                capsuleButton
                
                // Focus Label
                Text(focusLabel)
                    .font(sizeClass == .regular ? .largeTitle : .title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 80)
                
                Spacer()
                
                // Start Button
                Button {
                    model.Start()
                    softHaptic()
                } label: {
                    HStack {
                        Image(systemName: model.mode == .flowRunning || model.mode == .breakRunning ? "pause.fill" : "play.fill")
                            .font(.title)
                            .frame(width: 20, height: 20)
                    }
                    .padding(20)
                    .background(.teal.quinary)
                    .cornerRadius(100)
                }
            }
            
            // Circlers
            Circles(
                model: model,
                size: sizeClass == .regular ? 432: 304,
                width: sizeClass == .regular ? 30 : 20)
            
            // Timer Label
            Text(timerLabel)
                .font(.system(size: 76))
                .fontWeight(.light)
                .monospacedDigit()
            if model.flowExtended {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.trailing, 236)
            }
            
            // Complete & Extend
            Button {
                if model.mode == .breakRunning || model.mode == .breakPaused {
                    model.endBreak()
                } else {
                    completeAndExtend()
                }
            } label: {
                HStack {
                    Text("Complete")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .fontDesign(.rounded)
                }
            }
            .padding(.bottom, 112)
        }
    }
    
    var capsuleButton: some View {
        Button {
            model.showFlowRunning.toggle()
            lightHaptic()
        } label: {
            Capsule()
                .foregroundStyle(.white.quinary)
                .frame(width: 36, height: 5)
                .padding(.top, sizeClass == .regular ? 16 : 0)
                .padding(.bottom, 12)
                .padding(.top, 8)
                .padding(.horizontal)
                .gesture(
                    DragGesture()
                        .onChanged { _ in model.showFlowRunning.toggle() }
                        .onEnded { _ in }
                )
        }
    }
    
    // use variables for currentblock, nextBlock, previousBlock
    
    var currentBlock: Block {
        if model.mode == .flowRunning || model.mode == .flowPaused {
            return model.flow.blocks[model.blocksCompleted]
        } else if model.mode == .flowStart {
            return model.flow.blocks[model.blocksCompleted - 1]
        }
        return Block()
    }
    
    var focusLabel: String {
        if model.mode == .flowStart {
            return model.flow.blocks[model.blocksCompleted - 1].title
        } else if model.mode == .breakRunning || model.mode == .breakPaused {
            return "Break"
        }
        return model.flow.blocks[model.blocksCompleted].title
    }
    
    var timerLabel: String {
        if model.mode == .flowStart {
            return "00:00"
        } else if model.mode == .breakRunning || model.mode == .breakPaused{
            return formatTime(seconds: model.breakTimeLeft)
        }
        return formatTime(seconds: model.flowTimeLeft)
    }
    
    func completeAndExtend() {
        if model.mode == .flowStart {
            model.extend()
        } else {
            model.Complete()
        }
        softHaptic()
    }
}

struct Circles: View {
    var model: FlowModel
    var size: CGFloat = 288
    var width: CGFloat = 20
    var glow: Bool = false
    var fill: Bool = false
    var fillAmount: CGFloat = 1.0
    
    var color: Color {
        if model.mode == .breakRunning || model.mode == .breakPaused {
            return Color.gray
        }
        return Color.teal
    }
    
    var body: some View {
        ZStack {
            
            // Ring
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(color, style: StrokeStyle(lineWidth: width,lineCap: .round))
                .frame(width: size)
            
            Circle()
                .trim(from: 0, to: circleFill)
                .stroke(color.opacity(glow ? 0.5 : 0.4), style: StrokeStyle(lineWidth: width,lineCap: .round))
                .blur(radius: glow ? 5 : 3)
                .frame(width: size)
            
            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(color.opacity(0.2), style: StrokeStyle(lineWidth: width,lineCap: .round))
                .frame(width: size)
        }
        .rotationEffect(.degrees(-90))
        .frame(width: size)
        .animation(.default, value: circleFill)
    }
    
    var circleFill: CGFloat {
        if fill {
            return fillAmount
        } else {
            
            // Initial
            if model.mode == .initial {
                return 0
            }
            
            // Flow Start
            else if model.mode == .flowStart {
                return 1.0
            }
            
            // Flow Running
            else if model.mode == .flowRunning || model.mode == .flowPaused {
                if model.flowExtended {
                    return 1.0
                } else {
                    return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
                }
            }
            
            // Flow Extended
            else if model.flowExtended {
                return 1.0
            }
            
            
            // Break Running
            else if model.mode == .breakRunning || model.mode == .breakPaused {
                return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft - 1)
            }
            
            
            return 0
        }
    }
}


#Preview {
    FlowRunning(model: FlowModel(mode: .flowRunning, flow: Flow(title: "Flow", blocks: [Block(title: "Focus")])))
}
