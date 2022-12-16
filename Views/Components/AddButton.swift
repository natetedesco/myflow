//
//  Components.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import SwiftUI

struct AddButtonLabel: View {
    var title: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .font(.headline)
                .font(.headline)
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
        }
        .foregroundColor(color)
    }
}
