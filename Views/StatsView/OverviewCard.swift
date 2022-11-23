//
//  OverviewCard.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/23/22.
//

import SwiftUI

struct OverviewCard: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center, spacing: 4) {
                Text("Today")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("1h 15m")
                    .font(.subheadline)
                    .foregroundColor(.myBlue)
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 4) {
                Text("This Week")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("5h 20m")
                    .font(.subheadline)
                    .foregroundColor(.myBlue)

            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center, spacing: 4) {
                Text("This Month")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("25h 23m")
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
        OverviewCard()
    }
}
