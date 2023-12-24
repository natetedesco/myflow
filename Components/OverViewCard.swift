//
//  OverViewCard.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct OverViewCard: View {
    @ObservedObject var data: FlowData
    
    var body: some View {

        HStack() {
            OverviewLabel(
                label: "Today",
                time: CGFloat(Double(data.todayTime) / (data.goalMinutes/60)),
                totalTime: data.todayTime
            )
            Spacer()
            OverviewLabel(
                label: "This Week",
                time: CGFloat(Double(data.thisWeekTime) / ((data.goalMinutes/60) * 7)),
                totalTime: data.thisWeekTime
            )
            Spacer()
            OverviewLabel(
                label: "This Month",
                time: CGFloat(Double(data.thisMonthTime) / ((data.goalMinutes/60) * Double(data.daysInCurrentMonth()))),
                totalTime: data.thisMonthTime
            )
        }
    }
}

struct OverviewLabel: View {
    var label: String
    var time: CGFloat
    var totalTime: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Gauge(value: (time/60), label: {Text("\(formatHours(time: totalTime))")})
                .gaugeStyle(.accessoryCircularCapacity)
            
                .tint(.teal)
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
