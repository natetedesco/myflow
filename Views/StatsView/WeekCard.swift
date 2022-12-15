//
//  WeekCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/23/22.
//

import SwiftUI

struct WeekCard: View {
    @ObservedObject var data: FlowData
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var daysTime = [0, 0, 0, 0, 0, 0, 0]
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                
                Text("Daily Flow Time Goal:")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                Text("2h")
                    .font(.subheadline)
                Spacer()
            }
            
            VStack {
                HStack(alignment: .center, spacing: 16) {
                    
                    ForEach(0..<self.data.thisWeekDays.count, id: \.self) { index in
                        BarGraph(
                            text: days[index],
                            color: index == data.dayOfTheWeek ? .myBlue : .gray,
                            value: CGFloat(data.thisWeekDays[index].time/10) // 10 is goal time
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .modifier(CustomGlass())
        }
    }
}

struct WeekCard_Previews: PreviewProvider {
    static var previews: some View {
        WeekCard(data: FlowData())
    }
}


