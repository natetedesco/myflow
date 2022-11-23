//
//  Goal.swift
//  MyFlow
//  Created by Nate Tedesco on 9/27/22.
//

import SwiftUI

struct Goal: View {
    @Binding var flow: Flow
//    @State var choose: Bool = false
        
//    var hours = [Int](0...60)
    
    var body: some View {
        VStack {
            Button {
//                choose.toggle()
            } label: {
                HStack {
                    Text("Goal")
                        .foregroundColor(.white)
                    Text("2 hours per day")
                        .foregroundColor(.gray)
                    Spacer()
                    Toggle(isOn: $flow.goal) {
                    }.toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
                }
            }

//            if choose {
//                HStack {
//                    Picker(selection: $flow.goalSelection, label: Text("")) {
//                        ForEach(0..<hours.count, id: \.self) {
//                            Text("\(hours[$0]) hours")
//                        }
//                    }
//                    .pickerStyle(.wheel)
//
//                    Picker(selection: $minuteSelection, label: Text("seconds")) {
//                        ForEach(0..<minutes.count, id: \.self) {
//                            Text("\(minutes[$0]) min")
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                }
//                .frame(maxWidth: .infinity, maxHeight: 170, alignment: .center)
//            }
        }
    }
}
