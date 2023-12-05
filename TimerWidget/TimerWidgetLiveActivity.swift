//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//  Created by Nate Tedesco on 5/2/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetLiveActivity: Widget {
    
    
    var body: some WidgetConfiguration {
        
        // Live Activity
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            let context = context.state
            
            HStack {
                ProgressView(timerInterval: context.value, countsDown: false, label: {
                    Text("")
                }, currentValueLabel: {
                    Text("")
                })
                .progressViewStyle(.circular)
                .tint(.teal)
                .frame(height: 64)
                
                Spacer()
                
                Text(context.blockName)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.teal)
                    .padding(.trailing, 8)
                
                
                ZStack {
                        if context.extend {
                            Text(context.start, style: .timer)
                        } else {
                            Text(timerInterval: context.value, countsDown: true)
                        }
                }
                .font(.largeTitle)
                .monospacedDigit()
                .multilineTextAlignment(.trailing)
                .foregroundColor(.teal)
            }
            .padding()
            .background(.black.opacity(0.5))
            //            .background(.ultraThinMaterial)
        }
        
        // Dynamic Island Expanded
    dynamicIsland: { context in
        
        DynamicIsland {
            DynamicIslandExpandedRegion(.leading) {
                HStack {
                    ProgressView(timerInterval: context.state.value, countsDown: false, label: {
                        Text("")
                    }, currentValueLabel: {
                        Text("")
                    })
                    .progressViewStyle(.circular)
                    .tint(.teal)
                    .frame(height: 64)
                }
            }
            
            DynamicIslandExpandedRegion(.center) {
                    Text(context.state.blockName)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.teal)
            }
            
            DynamicIslandExpandedRegion(.trailing) {
                
                ZStack {
                    if context.state.paused {
                        Text("\(formatTime(seconds: context.state.time))")
                    } else {
                        if context.state.extend {
                            Text(context.state.start, style: .timer)
                        } else {
                            Text(timerInterval: context.state.value, countsDown: true)
                        }
                    }
                }
                .font(.largeTitle)
                .monospacedDigit()
                .foregroundColor(.teal)
                .multilineTextAlignment(.trailing)
                .frame(maxHeight: .infinity, alignment: .center)
                
            }
            DynamicIslandExpandedRegion(.bottom) {}
            
            // Compact
        } compactLeading: {
            if context.state.paused {
                Text("\(formatTime(seconds: context.state.time))")
                    .foregroundColor(.teal)
                
            }
            else if context.state.extend {
                Text(context.state.start, style: .timer)
                    .monospacedDigit()
                    .multilineTextAlignment(.center)
                    .frame(width: 36)
                    .font(.footnote)
                    .foregroundColor(.teal)
                
            }
            else {
                Text(timerInterval: context.state.value, countsDown: true)
                    .monospacedDigit()
                //                    .multilineTextAlignment(.leading)
                                    .frame(width: 36)
                //                    .font(.footnote)
                    .foregroundColor(.teal)
            }

        } compactTrailing: {
            
            ProgressView(
                timerInterval: context.state.value,
                countsDown: false,
                label: { },
                currentValueLabel: { }
            )
            .progressViewStyle(.circular)
            
            ProgressView(timerInterval: context.state.value, countsDown: false, label: {
                Text("")
            }, currentValueLabel: {
                Text("")
            })
            .progressViewStyle(CircularProgressViewStyle(tint: .teal))
            
        }
        
        // Minimal
    minimal: {
        ProgressView(timerInterval: context.state.value, countsDown: false, label: {
        }, currentValueLabel: {})
        .progressViewStyle(.circular)
        .tint(.teal)
    }}}
}

struct TimerWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = TimerWidgetAttributes(name: "Me")
    static let contentState = TimerWidgetAttributes.ContentState(name: "Flow", blockName: "Cardio", value: .now...Date(), blocks: 5, blocksCompleted: 2)
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

extension Color {
    static func rgb(r: Double, g: Double, b: Double ) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    static let darkBackground = Color(#colorLiteral(red: 0.05882352941, green: 0.07058823529, blue: 0.08235294118, alpha: 1))
    static let teal = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
}


