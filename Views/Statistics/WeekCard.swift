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
                Text("Daily flow time goal:")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Text("\(data.goalSelection)h")
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            
            HStack {
            ForEach(0..<data.thisWeekDays.count, id: \.self) { i in
                HStack {
                    VStack {
                        ZStack {
                            BarGraph(value: (CGFloat(data.thisWeekDays[i].time/data.goalSelection)))
                            //                            Rectangle()
                            //                                .frame(width: 24, height: 60)
                            //                                .foregroundColor(.white)
                            //                                .cornerRadius(25)
                            //                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                        
                        Text(days[i])
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(i == data.dayOfTheWeek ? .myColor : .gray)
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
        .padding(.horizontal, 24)
        .cardGlass()
    }
}

struct BarGraph: View {
    var value: CGFloat = 0
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                .myColor.opacity(1.0),
                .myColor.opacity(0.5),
            ]
        ),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 25, height: 60)
                    .foregroundColor(.clear)
                    .background(Color.myColor.opacity(0.1))
                //                    .background(.ultraThinMaterial.opacity(0.5))
                
                Rectangle()
                    .frame(width: 25, height: min(value, 60))
                    .foregroundColor(.myColor)
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
