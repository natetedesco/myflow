//
//  DeleteButton.swift
//  MyFlow
//  Created by Nate Tedesco on 9/29/22.
//

import SwiftUI

struct DeleteButton: View {
    @ObservedObject var flowModel: FlowModel
    @Binding var flow: Flow
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
            flowModel.deleteFlow(id: flow.id)
        } label: {
            Text("Delete Flow")
                .padding(.top)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
        }    }
}
