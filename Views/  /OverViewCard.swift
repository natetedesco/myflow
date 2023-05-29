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
        
        HStack(alignment: .center) {
            OverviewLabel(label: "Today", time: data.todayTime)
            OverviewLabel(label: "This Week", time: data.thisWeekTime)
            OverviewLabel(label: "This Month", time: data.thisMonthTime)
        }
        .cardGlass()
    }
}

struct OverviewLabel: View {
    var label: String
    var time: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            FootNote(text: label)
            SubHeadline(text: "\(formatHoursAndMinutes(time: time))")
                .myBlue()
        }
        .maxWidth()
    }
}

struct OverViewCard_Previews: PreviewProvider {
    static var previews: some View {
        
        OverViewCard(data: FlowData())
            .previewBackGround()
        
    }
}
