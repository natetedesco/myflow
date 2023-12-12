//
//  WeekCard.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct WeekCard: View {
    @ObservedObject var data: FlowData
    @AppStorage("ProAccess") var proAccess = false
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ForEach(0..<data.thisWeekDays.count, id: \.self) { i in
                    HStack {
                        VStack {
                            ZStack(alignment: .bottom) {
                                Rectangle()
                                    .frame(width: 28, height: 68)
                                    .foregroundColor(.clear)
                                    .background(Color.teal.tertiary)
                                
                                Rectangle()
                                    .frame(width: 28, height: min(CGFloat(Double(data.thisWeekDays[i].time)/(data.goalMinutes/60)), 68))
                                    .foregroundColor(.teal)
                            }
                            .cornerRadius(24)
                            .compositingGroup()
                            
                            Text(days[i])
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(i == data.dayOfTheWeek ? .teal : .gray)
                                .frame(width: 24)
                                .padding(.top, 4)
                        }
                        if i != 6 {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
