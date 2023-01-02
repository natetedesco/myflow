//
//  DayButton.swift
//  MyFlow
//  Created by Nate Tedesco on 12/16/22.
//

import SwiftUI

struct DayButton: View {
    @State var day: String
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
                    .font(.callout)
                    .foregroundColor(isOn ? .myBlue : .gray)
            }
        }
    }
}

struct Chevron: View {
    var image: String
    
    var body: some View {
        Image(systemName: image)
            .font(Font.system(size: 20))
            .padding(.horizontal, 4)
    }
}

