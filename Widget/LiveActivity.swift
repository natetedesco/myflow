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
                VStack(alignment: .leading) {
                    Text(context.blockName)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.leading, 8)
                        .padding(.bottom, -8)
                    
                    ZStack {
                        if context.paused {
                            Text("\(formatTime(seconds: context.time))")
                        } else {
                            if context.extend {
                                Text(context.start - TimeInterval(context.time), style: .timer)
                            } else {
                                Text(timerInterval: context.value, countsDown: true)
                            }
                        }
                    }
                    .font(.system(size: 44))
//                    .fontWeight(.medium)
                    .monospacedDigit()
                    .fontWeight(.light)
//                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                ProgressView(timerInterval: context.value, countsDown: false, label: {
                    Text("")
                }, currentValueLabel: {
                    Text("")
                })
                .progressViewStyle(.circular)
                .tint(.teal)
                .frame(height: 64)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        
        // Dynamic Island Expanded
    dynamicIsland: { context in
        DynamicIsland {
            DynamicIslandExpandedRegion(.leading) {
                VStack(alignment: .leading) {
                    Text(context.state.blockName)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                        .padding(.leading, 8)
                        .padding(.bottom, -8)
                    
                    ZStack {
                        if context.state.paused {
                            Text("\(formatTime(seconds: context.state.time))")
                        } else {
                            if context.state.extend {
                                Text(context.state.start + TimeInterval(context.state.time), style: .timer)
                            } else {
                                Text(timerInterval: context.state.value, countsDown: true)
                            }
                        }
                    }
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .monospacedDigit()
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity, alignment: .leading)
                }
            }
            DynamicIslandExpandedRegion(.center) {}
            
            DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .center) {
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
            DynamicIslandExpandedRegion(.bottom) {}
            
            // Compact
        } compactLeading: {
            ZStack {
                if context.state.extend {
                    Text(context.state.start + TimeInterval(context.state.time), style: .timer)
                } else {
                    Text(timerInterval: context.state.value, countsDown: true)
                }
            }
            .monospacedDigit()
            .font(.caption)
            .fontWeight(.medium)
            .frame(width: 40)
            .foregroundColor(.teal)

        } compactTrailing: {
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
