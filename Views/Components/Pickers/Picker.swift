//
//  Picker.swift
//  MyFlow
//  Created by Nate Tedesco on 1/20/23.
//

import SwiftUI

struct PickerView: View {
    @Binding var selection: Int
    var unit: [Int]
    var label: String
    
    var body: some View {
        
        GeometryReader { geometry in
            Picker(selection: $selection, label: Text("")) {
                ForEach(unit, id: \.self) { unit in
                    Text("\(unit) \(label)")
                }
            }
            .pickerStyle(.wheel)
        }
        .frame(height: 150)
        .padding(.vertical, -8)
    }
}

struct PickerLabel: View {
    var text: String
    var time: Int
    var color: Color
    
    var body: some View {
        HStack {
            Headline(text: text)
            Text(formatTime(seconds: time))
        }
        .foregroundColor(color)
        .leading()
    }
}
