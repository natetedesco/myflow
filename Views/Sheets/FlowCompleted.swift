//
//  FlowCompleted.swift
//  MyFlow
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI

struct FlowCompletedView: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            
            VStack {
                
                Spacer()
                
                Circles(model: model, size: 80, width: 8.0, fill: true)
                
                Spacer()
                
                Text("Flow Completed")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 8)
                
                HStack(alignment: .bottom) {
                    Text("Total Flow Time:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(formatHoursAndMinutes(time: model.settings.multiplyTotalFlowTime ? model.totalFlowTime * 60 : model.totalFlowTime))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
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
}

#Preview {
    ZStack {
        
    }
    .sheet(isPresented: .constant(true), content: {
        FlowCompletedView(model: FlowModel())
            .presentationBackground(.regularMaterial)
            .presentationCornerRadius(40)
            .presentationDetents([.fraction(6/10)])
    })
}
