//
//  TimerLabels.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct TimerLabels: View {
    @ObservedObject var model: FlowModel
    @Binding var mode: TimerMode
    
    var body: some View {
        ZStack {
            
            // Timer
            HStack {
                if model.flowContinue {
                    Image(systemName: "plus")
                        .foregroundColor(.myBlue)
                        .font(.title)
                }
                Text(timerLabel)
                    .font(.system(size: 72))
                    .fontWeight(.light)
                    .foregroundColor(model.type == .Flow ? .myBlue : .gray)
                    .kerning(3.0)
                .monospacedDigit()
            }
            
            // Block
            HStack {
                Circle()
                    .fill(block.flow ? Color.myBlue.opacity(0.6) : Color.gray.opacity(0.6))
                    .frame(height: 8)
                Text(block.title)
                    .foregroundColor(block.flow ? .myBlue.opacity(0.6) : .gray.opacity(0.6))
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.top, 128)
        }
        .animation(.easeInOut(duration: 0.3), value: mode)
    }
    
    var timerLabel: String {
        if model.type == .Flow {
            return formatTime(seconds: model.flowTimeLeft)
        }
        return formatTime(seconds: model.breakTimeLeft)
    }
    
    var block: Block {
        return model.flow.blocks[model.blocksCompleted]
    }
}


struct TimerLabel: View {
    var color: Color
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(color)
            .fontWeight(.light)
            .kerning(3.0)
            .monospacedDigit()
    }
}
