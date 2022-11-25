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
            
            if !model.simple {
                TimerLabel(color: .myBlue,
                           
                           text: "\(formatTime(seconds: model.flowTimeLeft))"
                )
                    .font(.system(size: 50))
                    .opacity(model.mode == .breakRunning ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: model.mode)
            }
            
            if model.simple {
                // Flow Label
                TimerLabel(color: .myBlue, text: "\(formatTime(seconds: model.flowTimeLeft))")
                
                    .modifier(AnimatingFontSize(fontSize: model.mode == .flowRunning ? 50 : 30))
                    .scaleEffect(model.mode == .breakRunning ? 0.0 : 1.0)
                    .padding(.trailing, model.mode == .flowRunning ? 0 : 120)
                    .opacity(model.mode == .breakRunning ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: model.mode)
                
                // Break Label
                TimerLabel(color: .gray, text: "\(formatTime(seconds: model.breakTimeLeft))")
                    .modifier(AnimatingFontSize(fontSize: model.mode == .breakRunning ? 50 : 30))
                    .scaleEffect(model.mode == .flowRunning ? 0.0 : 1.0)
                    .padding(.leading, model.mode == .breakRunning ? 0 : 120)
                    .opacity(model.mode == .flowRunning ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: model.mode)
            }
        }
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
