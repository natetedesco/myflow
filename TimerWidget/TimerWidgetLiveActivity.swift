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
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(context.state.flow ? .myBlue : .gray)
                    .font(.system(size: 30))
                Text("\(context.state.name)")
                    .font(.title3)
                    .foregroundColor(.white)
                Spacer()
                Text(timerInterval: context.state.value, countsDown: true)
                    .frame(width: 45)
            }
            .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                    Image(systemName: "circle")
                            .foregroundColor(context.state.flow ? .myBlue : .gray)
                        .font(.system(size: 40))
                        Text(context.state.name)
                            .font(.title3)

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
                            Text(timerInterval: context.state.value, countsDown: true)
                                .multilineTextAlignment(.center)
                                .frame(width: 50, height: 50)
                                .padding(.trailing)
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
                } else {
                Text(timerInterval: context.state.value, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                }
            } minimal: {
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
    static let contentState = TimerWidgetAttributes.ContentState(flow: true, name: "Flow", value: .now...Date())

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
