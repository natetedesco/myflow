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
                    Text(model.flow.blocks[model.blocksCompleted].title)
                        .foregroundColor(model.flow.blocks[model.blocksCompleted].flow ? .myBlue.opacity(0.6) : .gray.opacity(0.6))
                        .font(.title3)
                        .padding(.top, 90)
                    
                    TimerLabel(color: model.type == .Flow ? .myBlue : .gray, text: customLabel)
                        .font(.system(size: 50))
            }
            
            // Simple
            if model.flowMode == .Simple {
                HStack(alignment: .center) {
                    
                    if showFlowLabel {
                        FlowLabel
                    }
                    if showSpacer {
                        Spacer()
                            .frame(width: 44)
                    }
                    if showBreakLabel {
                        BreakLabel
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Rounds
                HStack {
                    if model.mode == .Initial {
                        ForEach(0 ..< model.roundsSet, id: \.self) {_ in RoundCircle() }
                    }
                    else {
                        ForEach(0 ..< model.roundsCompleted, id: \.self) {_ in RoundCircle() }
                        
                        if (model.mode == .flowRunning || model.mode == .flowPaused) && !model.flowContinue {
                            RoundCircle(half: true)
                        }
                    }
                }
                .padding(.top, 100)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: model.mode)
    }
    
    var BreakLabel: some View {
        TimerLabel(color: .gray, text: breakLabel)
            .modifier(AnimatingFontSize(fontSize: model.mode == .breakRunning || model.mode == .breakStart ? 60 : 35))
            .scaleEffect(model.mode == .flowRunning || model.mode == .flowStart ? 0.0 : 1.0)
    }
    
    var FlowLabel: some View {
        TimerLabel(color: .myBlue, text: flowLabel)
            .modifier(AnimatingFontSize(fontSize: model.mode == .flowRunning || model.mode == .flowStart ? 60 : 35))
            .scaleEffect(model.mode == .breakRunning || model.mode == .breakStart ? 0.0 : 1.0)
    }
    
    var showSpacer: Bool {
        if model.mode == .Initial || model.mode == .flowPaused || model.mode == .breakPaused {
        return true
        }
        return false
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
    
    var showFlowLabel: Bool {
        if model.mode == .Initial || model.mode == .flowStart || model.mode == .flowRunning || model.mode == .breakPaused || model.mode == .flowPaused {
            return true
        }
        return false
    }
    
    var showBreakLabel: Bool {
        if model.mode == .Initial || model.mode == .breakStart || model.mode == .breakRunning || model.mode == .breakPaused || model.mode == .flowPaused {
            return true
        }
        return false
    }
}

struct RoundCircle: View {
    var half: Bool = false
    var body: some View {
        Circle()
            .trim(from: 0, to: half ? 0.5 : 1.0)
            .rotationEffect(.degrees(90))
            .frame(width: 10, height: 10)
            .foregroundColor(.gray.opacity(0.3))
            .padding(1)
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

extension HorizontalAlignment {

    // A custom horizontal alignment to custom align views horizontally
    private struct CustomHorizontalAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            // Default to center alignment if no guides are set
            context[VerticalAlignment.center]
        }
    }

    static let customHorizontalAlignment = HorizontalAlignment(CustomHorizontalAlignment.self)
}
