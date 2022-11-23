//
//  FlowTitle.swift
//  MyFlow
//  Created by Nate Tedesco on 9/29/22.
//

import SwiftUI

struct FlowTitle: View {
    @Binding var flow: Flow
    @FocusState var focusedField: Field?
    
    var body: some View {
        TextField(flow.title, text: $flow.title)
            .font(.title)
            .foregroundColor(.gray)
            .focused($focusedField, equals: .flowname)
        
            .onAppear {
                if flow.new {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focusedField = .flowname }
                }
            }
    }
}

