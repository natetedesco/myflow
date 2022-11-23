//
//  Reminder.swift
//  MyFlow
//  Created by Nate Tedesco on 9/29/22.
//

import SwiftUI

struct Reminder: View {
    @Binding var flow: Flow
    
    var body: some View {
        HStack {
            Text("Reminder")
                .foregroundColor(.white)
            Text("5:00pm")
                .foregroundColor(.gray)
            Spacer()
            Toggle(isOn: $flow.reminder) {
            }.toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
        }
    }
}

//struct DayPicker: View {
//    @Binding var flow: Flow
//
//    var body: some View {
//        HStack(spacing: 15.0) {
//            DayButton(day: "M", isOn: $flow.monday)
//            DayButton(day: "T", isOn: $flow.tuesday)
//            DayButton(day: "W", isOn: $flow.wednesday)
//            DayButton(day: "T", isOn: $flow.thursday)
//            DayButton(day: "F", isOn: $flow.friday)
//            DayButton(day: "S", isOn: $flow.saturday)
//            DayButton(day: "S", isOn: $flow.sunday)
//        }
//        .padding(.top, 4)
//        .frame(maxWidth: .infinity, alignment: .center)
//    }
//}

//struct DayButton: View {
//    @State var day: String
//    @Binding var isOn: Bool
//
//    var body: some View {
//        Button {
//            isOn.toggle()
//        } label: {
//            ZStack {
//                Circle()
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(.black)
//                    .opacity(0.4)
//                Text(day)
//                    .foregroundColor(isOn == true ? .myBlue : .gray)
//            }
//        }
//    }
//}
