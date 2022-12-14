//
//  Charts.swift
//  MyFlow
//  Created by Nate Tedesco on 10/10/22.
//

import Foundation
import SwiftUI
import Charts

struct MonthCard: View {
    @ObservedObject var data: FlowData
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Monthly Flow Time Goal:")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                Text("20h")
                    .font(.subheadline)
                Spacer()
            }
            
//            Chart(data.presentedDays) { day in
//                LineMark(
//                    x: .value("Day", day.day, unit: .day),
//                    y: .value("Views", day.time)
//                )
//                PointMark(
//                    x: .value("Day", day.day, unit: .day),
//                    y: .value("Views", day.time)
//                )
//            }
            .accentColor(.myBlue)
            .frame(height: 120)
            .padding(8)
        }
        .frame(minHeight: 130) // temporary
        .modifier(CustomGlass())
    }
}

struct MonthCard_Previews: PreviewProvider {
    static var previews: some View {
        MonthCard(data: FlowData())
    }
}
