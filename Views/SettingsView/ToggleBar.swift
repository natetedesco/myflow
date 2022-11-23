//
//  ToggleBar.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import SwiftUI

struct ToggleBar: View {
    var text: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(text)
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
        .padding(.horizontal)
    }
}

struct SettingToggle: View {
    var text: String
    
    var body: some View {
        VStack {
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) { Text(text) }
                .foregroundColor(.white)
                .toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
            //                .padding(.horizontal, 30)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 180, alignment: .leading)
        .background(.black.opacity(0.5))
        .cornerRadius(25.0)
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
    }
}
