//
//  MonthCard.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI
import Charts

struct MonthCard: View {
    @ObservedObject var data: FlowData
    
    var yDateValues: [Date] {
            guard let firstDate = data.thisMonthDays.first?.day,
                  let lastDate = data.thisMonthDays.last?.day else {
                return []
            }

            let totalDays = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
            let strideValue = max(1, totalDays / 4) // Adjust the divisor as needed
            
            var currentDate = firstDate
            var dates: [Date] = []

            for _ in 0..<5 {
                if currentDate <= lastDate {
                    dates.append(currentDate)
                    currentDate = Calendar.current.date(byAdding: .day, value: strideValue, to: currentDate)!
                }
            }

            // Ensure the current date is included
            if currentDate <= lastDate {
                dates.append(currentDate)
            }

            return dates
        }
    
    var body: some View {
        Chart(data.thisMonthDays) { day in
            RuleMark(y: .value("Average", 120.0))
                .foregroundStyle(.teal.opacity(0.3))
                .lineStyle(.init(lineWidth: 0.1))
            
            LineMark(
                x: .value("Day", day.day),
                y: .value("Views", Double(day.time))
            )
            
            .symbol {
                Circle()
                    .fill(Color.teal)
                    .frame(width: 3)
            }
            AreaMark(
                x: .value("Day", day.day),
                y: .value("Views", Double(day.time))
            )
            
            .foregroundStyle(
                LinearGradient(colors: [.teal.opacity(0.7), .teal.opacity(0.0),], startPoint: .top, endPoint: .bottom)
            )
            .blur(radius: 1)
        }
        .frame(height: 160)
        .chartXAxis {
                    AxisMarks(values: yDateValues)
                }
    }
}
