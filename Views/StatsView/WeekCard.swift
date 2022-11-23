//
//  WeekCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/23/22.
//

import SwiftUI

struct WeekCard: View {
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

            HStack(alignment: .center, spacing: 16) {
                BarGraph(text: "M", value: 0.7)
                BarGraph(text: "T", value: 1.0)
                BarGraph(text: "W", value: 0.8)
                BarGraph(text: "T", value: 0.9)
                BarGraph(text: "F", color: .myBlue, value: 0.5)
                BarGraph(text: "S")
                BarGraph(text: "S")
            }
        }
        .frame(maxWidth: .infinity)
        .modifier(CustomGlass())
    }
}

struct WeekCard_Previews: PreviewProvider {
    static var previews: some View {
        WeekCard()
    }
}
