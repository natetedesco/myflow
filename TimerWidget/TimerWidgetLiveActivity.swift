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
            VStack {
                HStack {
                    Image(systemName: "circle")
                        .foregroundColor(context.state.flow ? .myBlue : .gray)
                        .font(.system(size: 30))
                    Text(context.state.flow ? "Flow" : "Break")
                        .font(.headline)
                    Spacer()
                }
                
                HStack {
                    
                    HStack {
                        Text(context.state.blockName)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    
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
                    .padding(.trailing, 4)
                    
                }.padding(.leading, 4)
                
                ProgressView(timerInterval: context.state.value, countsDown: false, label: {
                    Text("")
                }, currentValueLabel: {
                    Text("")
                })
                .tint(context.state.flow ? .myBlue : .gray)
                .padding(.horizontal, 4)
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
                
            }
            .padding(.top)
            .padding(.horizontal)
            .background(.black.opacity(0.5))
        }
        
        // Dynamic Island Expanded
    dynamicIsland: { context in
        DynamicIsland {
            DynamicIslandExpandedRegion(.leading) {
                HStack {
                    Image(systemName: "circle")
                        .foregroundColor(context.state.flow ? .myBlue : .gray)
                        .font(.system(size: 30))
                    Text(context.state.flow ? "Flow" : "Break")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
            DynamicIslandExpandedRegion(.trailing) {}
            DynamicIslandExpandedRegion(.bottom) {
                HStack {
                    
                    HStack {
                        Text(context.state.blockName)
                            .font(.callout)
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    
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
                    .padding(.trailing, 4)
                    
                }
                .padding(.leading, 4)
                .padding(.bottom, -4)
                
                ProgressView(timerInterval: context.state.value, countsDown: false, label: {
                    Text("")
                }, currentValueLabel: {
                    Text("")
                })
                .tint(context.state.flow ? .myBlue : .gray)
                .padding(.horizontal, 4)
                .padding(.bottom, -16)
            }
            
            // Compact
        } compactLeading: {
            Image(systemName: "circle")
                .foregroundColor(context.state.flow ? .myBlue : .gray)
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
    static let myBlue = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
}

struct RoundCircle: View {
    var half: Bool = false
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: half ? 0.5 : 1.0)
                .rotationEffect(.degrees(90))
                .frame(width: 10, height: 10)
                .foregroundColor(.gray.opacity(0.3))
                .padding(1)
            //            if half {
            //                Circle()
            //                .stroke(Color.gray.opacity(0.3),style: StrokeStyle(lineWidth: 1.5 ,lineCap: .round))
            //                .frame(width: 10, height: 10)
            //                .padding(1)
            //            }
        }
    }
}

struct RoundCircleStroke: View {
    var half: Bool = false
    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3),style: StrokeStyle(lineWidth: 1.5 ,lineCap: .round))
            .frame(width: 10, height: 10)
            .padding(1)
    }
}
