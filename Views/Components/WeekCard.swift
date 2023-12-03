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
//            HStack {
//                Text("Daily flow time goal:")
//                    .font(.footnote)
//                    .fontWeight(.medium)
//                    .foregroundStyle(.secondary)
//                Text("\(data.goalSelection)h")
//                    .font(.footnote)
//                    .fontWeight(.medium)
//            }
            
            HStack {
            ForEach(0..<data.thisWeekDays.count, id: \.self) { i in
                HStack {
                    VStack {
                        ZStack {
                            BarGraph(value: (CGFloat(data.thisWeekDays[i].time/data.goalSelection)))
                        }
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
//        .padding(.top, 8)
//        .cardGlass()
    }
}

struct BarGraph: View {
    var value: CGFloat = 0
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                .teal.opacity(1.0),
                .teal.opacity(0.5),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 28, height: 68)
                    .foregroundColor(.clear)
                    .background(Color.teal.quaternary)
                //                    .background(.ultraThinMaterial.opacity(0.5))
                
                Rectangle()
                    .frame(width: 25, height: min(value, 60))
                    .foregroundColor(.teal)
            }
            .cornerRadius(25)
        }
    }
}

struct WeekCard_Previews: PreviewProvider {
    static var previews: some View {
        WeekCard(data: FlowData())
    }
}