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
                TimerLabel(color: model.type == .Flow ? .myBlue : .white.opacity(0.8), text: customLabel)
                    .font(.system(size: 76))
                    .fontWeight(.bold)
                
            // Block
                HStack {
                    Circle()
                        .fill(Color.myBlue)
                        .frame(height: 8)
                    Text(model.flow.blocks[model.blocksCompleted].title)
                        .foregroundColor(model.flow.blocks[model.blocksCompleted].flow ? .myBlue.opacity(0.6) : .white.opacity(0.6))
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.top, 128)
        }
        .animation(.easeInOut(duration: 0.3), value: mode)
    }
    
    var FlowLabel: some View {
        HStack {
            if model.flowContinue {
                Text("+")
                    .foregroundColor(.myBlue)
                    .font(.system(size: 45))
                    .fontWeight(.light)
            }
            TimerLabel(color: .myBlue, text: (formatTime(seconds: model.flowTimeLeft)))
                .modifier(AnimatingFontSize(fontSize: mode == .Initial ? 35 : 60))
        }
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

//if model.flowContinue {
//                Text(model.flow.blocks[model.blocksCompleted - 1].title)
//                    .foregroundColor(.myBlue.opacity(0.6))
//                    .font(.title3)
////                    .padding(.top, 90)
//
//                HStack {
//                    TimerLabel(color: .myBlue, text: ("+\(formatTime(seconds: model.flowTimeLeft))"))
//                        .font(.system(size: 100))
//                }
//            }
