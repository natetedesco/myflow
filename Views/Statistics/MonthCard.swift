//
//  MonthCard.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI
import Charts

struct MonthCard: View {
    @ObservedObject var data: FlowData
    
    var body: some View {
        VStack {
            Chart(data.thisMonthDays) { day in
                LineMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
                AreaMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
                .foregroundStyle(curGradient)
                .blur(radius: 1)
            }
            .accentColor(.myColor)
            .frame(height: 160)
//            .padding(.top, 8)
//            .padding(.horizontal, 8)
        }
//        .cardGlass()
    }
}

let curGradient = LinearGradient(
    gradient: Gradient (
        colors: [
            .myColor.opacity(0.6),
//            .myColor.opacity(0.2),
            .myColor.opacity(0.0),
        ]
    ),
    startPoint: .top,
    endPoint: .bottom
)

struct MonthCard_Previews: PreviewProvider {
    static var previews: some View {
        MonthCard(data: FlowData())
    }
}
