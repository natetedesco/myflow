//
//  Components.swift
//  MyFlow
//  Created by Nate Tedesco on 9/20/22.
//

import SwiftUI

struct SheetCapsule: View {
    var body: some View {
        Capsule()
            .fill(Color.secondary)
            .opacity(0.5)
            .frame(width: 35, height: 5)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct FlowModePicker: View {
    @Binding var simple: Bool
    
    var body: some View {
        Picker("", selection: $simple, content: {
            Text("Simple").tag(true)
            Text("Custom").tag(false)
        })
        .pickerStyle(SegmentedPickerStyle())
        .preferredColorScheme(.dark)
        .padding(.bottom)
    }
}

struct CategoryView: View {
    var body: some View {
        Button {
            
        } label: {
            Text("Category")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(CustomGlass())
        }
    }
}

struct PlusButton: View {
    var body: some View {
        Image(systemName: "plus")
            .foregroundColor(.myBlue)
            .font(.headline)
            .padding(11)
            .background(Circle().fill(.ultraThinMaterial))
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

enum Field: Hashable {
    case flowname
}
