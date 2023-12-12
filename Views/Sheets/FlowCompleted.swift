//
//  FlowCompleted.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI

struct ShowFlowCompletedView: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Circles(model: model, size: 128, width: 14.0, fill: true)
                    .padding(.top, 32)
                    .padding(.bottom)
                
                Spacer()
                
                Text("Flow Completed")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                HStack(alignment: .bottom) {
                    Text("Total Flow Time:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(formatHoursAndMinutes(time: model.settings.multiplyTotalFlowTime ? model.totalFlowTime * 60 : model.totalFlowTime))
                        .font(.callout)
                        .fontWeight(.semibold)
                }
                
                // For Debugging
//                    Text("\(model.totalFlowTime)")
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Dismiss")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.teal)
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 24)
        }
        .accentColor(.teal)
    }
}

