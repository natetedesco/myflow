//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//  Created by Nate Tedesco on 5/2/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

//struct TimerWidgetAttributes: ActivityAttributes {
//    public typealias TimerStatus = ContentState
//
//    public struct ContentState: Codable, Hashable {
//        var flow: Bool
//        var name: String
//        var blockName: String
//
//        var value: ClosedRange<Date>
//        var paused: Bool = false
//
//        var time: Int = 0
//        var start: Date = Date()
//        var extend: Bool = false
//
//        var blocks: Int
//        var blocksCompleted: Int
//    }
//    var name: String
//}


struct TimerWidgetLiveActivity: Widget {
    
    
    var body: some WidgetConfiguration {
        
        // Live Activity
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            let context = context.state
            
            VStack {
                HStack {
                    //                    Image(systemName: "circle")
                    //                        .foregroundColor(context.flow ? .myColor : .gray)
                    //                        .font(.system(size: 28))
                    
                    Circle()
                        .stroke(Color.myColor, style: StrokeStyle(lineWidth: 3,lineCap: .round))
                        .frame(width: 24)
                    
                    Text(context.name)
                        .font(.title2)
                        .fontWeight(.medium)
                    Spacer()
                }
                
                HStack {
                    //                    Circle()
                    //                        .fill(context.flow ? Color.myColor : Color.gray)
                    //                        .frame(height: 8)
                    Text(context.blockName)
                        .foregroundColor(context.flow ? .myColor : .gray)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    ZStack {
                        if context.paused {
                            Text("\(formatTime(seconds: context.time))")
                        } else {
                            if context.extend {
                                Text(context.start, style: .timer)
                            } else {
                                Text(timerInterval: context.value, countsDown: true)
                                //                                    .font(.headline)
                            }
                        }
                    }
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 4)
                
                ProgressView(timerInterval: context.value, countsDown: false, label: {
                    Text("")
                }, currentValueLabel: {
                    Text("")
                })
                .tint(context.flow ? .myColor : .gray)
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
            }
            .padding(.horizontal)
            .padding(.top)
            .background(.black.opacity(0.5))
            //            .background(.ultraThinMaterial)
        }
        
        // Dynamic Island Expanded
    dynamicIsland: { context in
        
        
        DynamicIsland {
            DynamicIslandExpandedRegion(.leading) {
                HStack {
                    Circle()
                        .stroke(Color.myColor, style: StrokeStyle(lineWidth: 3,lineCap: .round))
                        .frame(width: 24)
                    
                    Text(context.state.name)
                        .font(.title2)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(.top, 8)
            }
            DynamicIslandExpandedRegion(.trailing) {}
            DynamicIslandExpandedRegion(.bottom) {
                VStack {
                    HStack {
                        
                        HStack {
                            Text(context.state.blockName)
                                .foregroundColor(context.state.flow ? .myColor : .gray)
                                .font(.headline)
                            Spacer()
                        }
                        
                        Spacer()
                        
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
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.white.opacity(0.8))
                    }
                    
                    ProgressView(timerInterval: context.state.value, countsDown: false, label: {
                        Text("")
                    }, currentValueLabel: {
                        Text("")
                    })
                    .tint(context.state.flow ? .myColor : .gray)
                }
                .padding(.top, 4)
                .padding(.bottom, -12)
            }
            
            // Compact
        } compactLeading: {
            Image(systemName: "circle")
                .foregroundColor(context.state.flow ? .myColor : .gray)
                .font(.system(size: 20))
        } compactTrailing: {
            if context.state.paused {
                Text("\(formatTime(seconds: context.state.time))")
            } else if context.state.extend {
                Text(context.state.start, style: .timer)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.footnote)
            } else {
                Text(timerInterval: context.state.value, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.footnote)
            }
        }
        
        // Minimal
    minimal: {
        if context.state.paused {
            Text("\(formatTime(seconds: context.state.time))")
                .multilineTextAlignment(.center)
                .frame(width: 35)
                .font(.system(size: 12))
        } else if context.state.extend {
            Text(context.state.start, style: .timer)
                .multilineTextAlignment(.center)
                .frame(width: 35)
                .font(.system(size: 12))
        } else {
            Text(timerInterval: context.state.value, countsDown: true)
                .multilineTextAlignment(.center)
                .frame(width: 35)
                .font(.system(size: 12))
        }
    }
    .keylineTint(Color.white)
    }
    }
}

struct TimerWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = TimerWidgetAttributes(name: "Me")
    static let contentState = TimerWidgetAttributes.ContentState(flow: true, name: "Flow", blockName: "Cardio", value: .now...Date(), blocks: 5, blocksCompleted: 2)
    
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
    static let myColor = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
}


