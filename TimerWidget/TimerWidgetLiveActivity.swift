//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Nate Tedesco on 5/2/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetLiveActivity: Widget {
    var progress = 0.5
    var progress2 = 0.0
    var progress3 = 1.0


    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            
                VStack {
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(context.state.flow ? .myBlue : .gray)
                            .font(.system(size: 30))
                        Text("\(context.state.name)")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                        if context.state.paused {
                            Text("\(formatTime(seconds: context.state.time))")
                                .frame(width: 50, height: 50)
                                .padding(.trailing)
                        } else {
                            if context.state.extend {
                                Text(context.state.start, style: .timer)
                                    .frame(width: 55)
                            } else {
                                Text(timerInterval: context.state.value, countsDown: true)
                                    .frame(width: 55)
                            }
                        }
                    }.padding(.bottom, 8)
                    HStack {
                        // only for custom
//                        Text("Workout -")
//                        Text("Cardio")
//                            .font(.subheadline)
//                            .fontWeight(.bold)
//                        Spacer()
                    }
                    HStack {
                        ProgressView(value: 1.0)
                        ProgressView(value: 1.0)
                        ProgressView(value: 0.25)
                        ProgressView(value: 0.0)
                        ProgressView(value: 0.0)
                        

                    }.padding(.top, 4).padding(.horizontal, 4)
                        .accentColor(.myBlue)
                }
                .padding()
                .background(.black.opacity(0.5))
            
            
        } dynamicIsland: { context in
            
            // Dynamic Island
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(context.state.flow ? .myBlue : .gray)
                            .font(.system(size: 40))
                        Text(context.state.name)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 50)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        if context.state.paused {
                            Text("\(formatTime(seconds: context.state.time))")
                                .frame(width: 50, height: 50)
                                .padding(.trailing)
                        } else {
                            if context.state.extend {
                                Text(context.state.start, style: .timer)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                            } else {
                                Text(timerInterval: context.state.value, countsDown: true)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing)
                            }
                        }
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                }
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
                } else {
                    Text(timerInterval: context.state.value, countsDown: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                }
            }
            
            // Minimal
        minimal: {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 2,lineCap: .round))
                .frame(width: 22)
        }
        .keylineTint(Color.white)
        }
    }
}

struct TimerWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = TimerWidgetAttributes(name: "Me")
    static let contentState = TimerWidgetAttributes.ContentState(flow: true, custom: true, name: "Flow", value: .now...Date())
    
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
