//
//  FlowCompletedLabel.swift
//  MyFlow
//  Created by Nate Tedesco on 12/16/22.
//

import SwiftUI

struct FlowCompleted: View {
    @ObservedObject var model: FlowModel

    var body: some View {
        Text("Flow Completed")
            .padding(.bottom, 500)
            .foregroundColor(.myBlue)
            .onTapGesture {
                model.completed = false
            }
    }
}
