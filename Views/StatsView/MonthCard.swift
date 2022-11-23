//
//  Charts.swift
//  MyFlow
//  Created by Nate Tedesco on 10/10/22.
//

import Foundation
import SwiftUI
import Charts

struct MountPrice: Identifiable {
    var id = UUID()
    var mount: String
    var value: Double
}

struct MonthCard: View {
    let data: [MountPrice] = [
        MountPrice(mount: "jan", value: 5),
        MountPrice(mount: "feb", value: 4),
        MountPrice(mount: "mar", value: 7),
        MountPrice(mount: "apr", value: 15),
        MountPrice(mount: "may", value: 14),
        MountPrice(mount: "jun", value: 27)
    ]
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()

                Text("Monthly Flow Time Goal:")
                    .foregroundColor(.gray)
                    .font(.footnote)

                Text("20h")
                    .font(.subheadline)
                Spacer()
            }
            Chart(data) {
                LineMark(
                    x: .value("Mount", $0.mount),
                    y: .value("Value", $0.value)
                )
                PointMark(
                    x: .value("Mount", $0.mount),
                    y: .value("Value", $0.value)
                )
            }
            .accentColor(.myBlue)
            .frame(height: 120)
                .padding(8)
        }
        .frame(minHeight: 130) // temporary
        .modifier(CustomGlass())
        

    }
}
