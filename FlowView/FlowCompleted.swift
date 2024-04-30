//
//  FlowCompleted.swift
//  MyFlow
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI

struct FlowCompletedView: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var showRateTheApp: Bool
    @AppStorage("ratedTheApp") var ratedTheApp: Bool = false

    var body: some View {
        
        VStack {
            
            Spacer()
            
            Circles(model: model, size: 72, width: 7.0, fill: true)
            
            Spacer()
            
            Text("Flow Completed")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            
            HStack(alignment: .bottom) {
                Text("Total Flow Time:")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Text(formatHoursAndMinutes(time: model.settings.multiplyTotalFlowTime ? model.totalFlowTime * 60 : model.totalFlowTime))
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            Button {
                dismiss()
                if !ratedTheApp && model.totalFlowTime > 600 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showRateTheApp = true
                    }
                }
                
            } label: {
                Text("Dismiss")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.teal)
                    .cornerRadius(20)
            }
            
            // only if completed, not reset
//            Button {
//                
//            } label: {
//                Text("Extend last focus")
//                    .font(.footnote)
//                    .fontWeight(.medium)
//            }
//            .padding(.top)
        }
        .padding(.horizontal, 24)
        
    }
}

#Preview {
    ZStack {}
    .sheet(isPresented: .constant(true), content: {
        FlowCompletedView(model: FlowModel(), showRateTheApp: .constant(false))
            .presentationBackground(.regularMaterial)
            .presentationCornerRadius(40)
            .presentationDetents([.fraction(6/10)])
    })
}
