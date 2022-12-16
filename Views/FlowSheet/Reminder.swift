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

