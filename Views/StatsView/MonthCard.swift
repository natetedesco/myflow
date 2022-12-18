//
//  Charts.swift
//  MyFlow
//  Created by Nate Tedesco on 10/10/22.
//

import SwiftUI
import Charts

struct MonthCard: View {
    @ObservedObject var data: FlowData
    @AppStorage("GoalTime") var goalSelection: Int = 2
    
    var body: some View {
        VStack {
            
            Chart(data.thisMonthDays) { day in
                LineMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
                PointMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
            }
            .accentColor(.myBlue)
            .frame(height: 120)
            .padding(.top, 8)
            .padding(8)
        }
        .modifier(CustomGlass())
    }
}

struct MonthCard_Previews: PreviewProvider {
    static var previews: some View {
        MonthCard(data: FlowData())
    }
}
