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
            // Custom
            if model.flowMode == .Custom {
                if model.flowContinue {
                    Text(model.flow.blocks[model.blocksCompleted - 1].title)
                        .foregroundColor(.myBlue.opacity(0.6))
                        .font(.title3)
                        .padding(.top, 90)
                    
                    TimerLabel(color: .myBlue, text: ("+\(formatTime(seconds: model.flowTimeLeft))"))
                        .font(.system(size: 50))
                }
                else {
                    Text(model.flow.blocks[model.blocksCompleted].title)
                        .foregroundColor(model.flow.blocks[model.blocksCompleted].flow ? .myBlue.opacity(0.6) : .gray.opacity(0.6))
                        .font(.title3)
                        .padding(.top, 90)
                    
                    TimerLabel(color: model.type == .Flow ? .myBlue : .gray, text: customLabel)
                        .font(.system(size: 50))
                }
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
                .maxWidth()
                
                // Rounds
                HStack {
                    if mode == .Initial {
                        ForEach(0 ..< model.roundsSet, id: \.self) {_ in RoundCircle() }
                    }
                    else {
                        ForEach(0 ..< model.roundsCompleted, id: \.self) {_ in RoundCircle() }
                        
                        if (mode == .flowRunning || mode == .flowPaused) && !model.flowContinue {
                            RoundCircle(half: true)
                        }
                    }
                }
                .padding(.top, 100)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: mode)
    }
    
    var BreakLabel: some View {
        TimerLabel(color: .gray, text: breakLabel)
            .modifier(AnimatingFontSize(fontSize: mode == .breakRunning || mode == .breakStart ? 60 : 35))
            .scaleEffect(mode == .flowRunning || mode == .flowStart ? 0.0 : 1.0)
    }
    
    var FlowLabel: some View {
        TimerLabel(color: .myBlue, text: flowLabel)
            .modifier(AnimatingFontSize(fontSize: mode == .flowRunning || mode == .flowStart ? 60 : 35))
            .scaleEffect(mode == .breakRunning || mode == .breakStart ? 0.0 : 1.0)
    }
    
    var showSpacer: Bool {
        if mode == .Initial || mode == .flowPaused || mode == .breakPaused {
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
        if mode == .Initial || mode == .flowStart || mode == .flowRunning || mode == .breakPaused || mode == .flowPaused {
            return true
        }
        return false
    }
    
    var showBreakLabel: Bool {
        if mode == .Initial || mode == .breakStart || mode == .breakRunning || mode == .breakPaused || mode == .flowPaused {
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
