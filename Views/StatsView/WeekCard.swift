//
//  WeekCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/23/22.
//

import SwiftUI

struct WeekCard: View {
    @ObservedObject var data: FlowData
    @AppStorage("GoalTime") var goalSelection: Int = 2
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text("Daily Flow Time Goal:")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("\(goalSelection)h")
                    .font(.subheadline)
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 16) {
                ForEach(0..<self.data.thisWeekDays.count, id: \.self) { index in
                    BarGraph(
                        text: days[index],
                        color: index == data.dayOfTheWeek ? .myBlue : .gray,
                        value: (CGFloat(data.thisWeekDays[index].time))
                    )
                }
            }
        }
        .modifier(CustomGlass())
    }
}

struct WeekCard_Previews: PreviewProvider {
    static var previews: some View {
        WeekCard(data: FlowData())
    }
}


