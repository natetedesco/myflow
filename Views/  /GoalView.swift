//
//  GoalView.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var data: FlowData
    @Binding var show: Bool
    
    var hours = [Int](0...8)
    
    var body: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture {
                    show = false
                }
                .opacity(show ? 1.0 : 0.0)
                .animation(.default.speed(show ? 2.0 : 1.0), value: show)
            VStack {
                Title2(text: "Daily Flow Time Goal")
                    .padding(.bottom, 12)
                ZStack {
                    Picker(selection: $data.goalSelection, label: Text("")) {
                        ForEach(1..<hours.count, id: \.self) {
                            Text("\(hours[$0])")
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(-8)
                    .padding(.vertical, -16)
                    Text("Hours")
                        .padding(.leading, 80)
                }
            }
            .padding(24)
            .background(.black.opacity(0.7))
            .cornerRadius(40)
            .padding(.horizontal, 48)
            .opacity(show ? 1.0 : 0.0)
            .scaleEffect(show ? 1.0 : 0.97)
            .animation(.default.speed(show ? 1.0 : 2.0), value: show)
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            StatsView(data: FlowData())
            GoalView(data: FlowData(), show: .constant(true))
        }
    }
}
