//
//  DayButton.swift
//  MyFlow
//  Created by Nate Tedesco on 12/16/22.
//

import SwiftUI

struct DayButton: View {
    @State var day: String
//    @Binding var isOn: Bool
    @State var isOn: Bool = true

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                    .opacity(0.4)
                Text(day)
                    .foregroundColor(isOn == true ? .myBlue : .gray)
            }
        }
    }
}

