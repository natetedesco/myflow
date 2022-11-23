//
//  SaveButtonView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/28/22.
//

import SwiftUI

struct SaveButton: View {
    @ObservedObject var flowModel: FlowModel
    @Binding var flow: Flow
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
            if flow.new {
                flowModel.addFlow(flow: flow)
            } else {
                flowModel.editFlow(id: flow.id, flow: flow)
            }
        } label: {
            Text("Save")
                .font(.subheadline)
                .foregroundColor(.myBlue)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

