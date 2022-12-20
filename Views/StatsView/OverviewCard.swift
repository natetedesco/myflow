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
            OverviewLabel(label: "Today", time: data.todayTime)
            OverviewLabel(label: "This Week", time: data.thisWeekTime)
            OverviewLabel(label: "This Month", time: data.thisMonthTime)
        }
        .modifier(CustomGlass())
    }
}

struct OverviewLabel: View {
    var label: String
    var time: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(label)
                .foregroundColor(.gray)
                .font(.footnote)
            Text("\(formatHoursAndMinutes(time: time))")
                .font(.subheadline)
                .foregroundColor(.myBlue)
        }
        .frame(maxWidth: .infinity)
    }
}

struct OverviewCard_Previews: PreviewProvider {
    static var previews: some View {
        OverviewCard(data: FlowData())
    }
}
