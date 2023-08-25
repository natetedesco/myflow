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
        VStack(alignment: .center, spacing: 16) {
            HStack {
                FootNote(text: "Daily flow time goal:")
                SubHeadline(text: "\(data.goalSelection)h")
            }
            
            VStack {
                ZStack {
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(data.thisWeekDays) {_ in
                            Rectangle()
                                .frame(width: 25, height: 60)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    .blendMode(.destinationOut)
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(data.thisWeekDays) { day in
                            BarGraph(value: (CGFloat(day.time/data.goalSelection)))
                        }
                    }
                }
                HStack(alignment: .center, spacing: 16) {
                    ForEach(0..<self.data.thisWeekDays.count, id: \.self) { i in
                        FootNote(text: days[i])
                            .foregroundColor(i == data.dayOfTheWeek ? .myBlue : .gray)
                            .frame(width: 25)
                    }
                }
            }
        }
        .compositingGroup()
        .cardGlass()
    }
}

struct BarGraph: View {
    var value: CGFloat = 0
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                .myBlue.opacity(1.0),
                .myBlue.opacity(0.5),
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
                    .background(.ultraThinMaterial.opacity(0.5))
                
                Rectangle()
                    .frame(width: 25, height: min(value, 60))
                    .myBlue()
            }
            .cornerRadius(25)
        }
    }
}

struct WeekCard_Previews: PreviewProvider {
    static var previews: some View {
        WeekCard(data: FlowData())
            .previewBackGround()
    }
}
