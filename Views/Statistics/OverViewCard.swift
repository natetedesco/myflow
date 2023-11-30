//
//  OverViewCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct OverViewCard: View {
    @ObservedObject var data: FlowData
    
    var body: some View {
        
        HStack() {
            OverviewLabel(
                label: "Today",
                time: CGFloat(data.todayTime / data.goalSelection),
                totalTime: data.todayTime
            )
            Spacer()
            OverviewLabel(
                label: "This Week",
                time: CGFloat(data.thisWeekTime / (data.goalSelection * 7)),
                totalTime: data.thisWeekTime
            )
            Spacer()
            OverviewLabel(
                label: "This Month",
                time: CGFloat(data.thisMonthTime / (data.goalSelection * daysInCurrentMonth())),
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
            
                .tint(.myColor)
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

struct OverViewCard_Previews: PreviewProvider {
    static var previews: some View {
        
        OverViewCard(data: FlowData())
    }
}

func daysInCurrentMonth() -> Int {
    let calendar = Calendar.current
    let date = Date()
    
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    
    let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    
    let numberOfDays = calendar.range(of: .day, in: .month, for: endOfMonth)?.count ?? 0
    
    return numberOfDays
}
