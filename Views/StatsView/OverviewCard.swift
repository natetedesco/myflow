//
//  OverviewCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/23/22.
//

import SwiftUI

struct OverviewCard: View {
    @ObservedObject var data: FlowData
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center, spacing: 4) {
                Text("Today")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("\(data.todayTime)")
//                Text(formatHoursAndMinutes(time: 100))
                    .font(.subheadline)
                    .foregroundColor(.myBlue)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 4) {
                Text("This Week")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("\(data.thisWeekTime)")
//                Text(formatHoursAndMinutes(time: 1000))
                    .font(.subheadline)
                    .foregroundColor(.myBlue)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 4) {
                Text("This Month")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("\(data.thisMonthTime)")
//                Text(formatHoursAndMinutes(time: 10000))
                    .font(.subheadline)
                    .foregroundColor(.myBlue)
            }
            .frame(maxWidth: .infinity)
        }
        .modifier(CustomGlass())
    }
}

struct OverviewCard_Previews: PreviewProvider {
    static var previews: some View {
        OverviewCard(data: FlowData())
    }
}
