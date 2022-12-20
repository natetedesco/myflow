//
//  TimerLabels.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct TimerLabels: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        ZStack {
            // Custom
            if model.flowMode == .Custom {
                TimerLabel(color: model.type == .Flow ? .myBlue : .gray,text: customLabel)
                .font(.system(size: 50))
            }
            
            // Simple
            if model.flowMode == .Simple {
                // Flow Label
                TimerLabel(color: .myBlue, text: flowLabel)
                    .modifier(AnimatingFontSize(fontSize: model.mode == .flowRunning ? 50 : 30))
                    .scaleEffect(model.mode == .breakRunning ? 0.0 : 1.0)
                    .padding(.trailing, model.mode == .flowRunning ? 0 : 120)
                    .opacity(model.mode == .breakRunning ? 0.0 : 1.0)
                
                // Break Label
                TimerLabel(color: .gray, text: breakLabel)
                    .modifier(AnimatingFontSize(fontSize: model.mode == .breakRunning ? 50 : 30))
                    .scaleEffect(model.mode == .flowRunning ? 0.0 : 1.0)
                    .padding(.leading, model.mode == .breakRunning ? 0 : 120)
                    .opacity(model.mode == .flowRunning ? 0.0 : 1.0)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: model.mode)
    }
    
    var flowLabel: String {
        if model.flowContinue {
            return ("+\(formatTime(seconds: model.flowTimeLeft))")
        }
        return formatTime(seconds: model.flowTimeLeft)
    }
    
    var breakLabel: String {
        return formatTime(seconds: model.breakTimeLeft)
    }
    
    var customLabel: String {
        if model.type == .Flow {
            return formatTime(seconds: model.flowTimeLeft)
        }
        return formatTime(seconds: model.breakTimeLeft)
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

// Font Size Modifier
struct AnimatingFontSize: AnimatableModifier {
    var fontSize: CGFloat
    var animatableData: CGFloat {
        get { fontSize }
        set { fontSize = newValue }
    }
    
    func body(content: Self.Content) -> some View {
        content.font(.system(size: self.fontSize))
    }
}
