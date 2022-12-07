//
//  WeekCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/23/22.
//

import SwiftUI

struct WeekCard: View {
    var data: FlowData
    
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
                ForEach(data.days) { day in
                    BarGraph(value: 0)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .modifier(CustomGlass())
    }
}

struct WeekCard_Previews: PreviewProvider {
    static var previews: some View {
        WeekCard(data: FlowData())
    }
}
