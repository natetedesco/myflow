//
//  FlowCompleted.swift
//  MyFlow
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI

struct FlowCompletedView: View {
    @State var model: FlowModel
    @Environment(\.dismiss) var dismiss
    @State var dismissed = false
    
    @AppStorage("ratedTheApp") var ratedTheApp: Bool = false
    @AppStorage("askedForReating") var flowsCompleted = 0

    @Environment(\.requestReview) var requestReview

    var body: some View {
        ZStack {
            
            Circle()
                .foregroundStyle(.teal.opacity(0.5))
                .frame(height: 400)
                .blur(radius: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, -200)
                .padding(.leading, -300)
                .ignoresSafeArea()
                .opacity(dismissed ? 0.0 : 1.0)
                .animation(.easeOut, value: dismissed)
            
            Circle()
                .foregroundStyle(.teal.opacity(0.5))
                .frame(height: 400)
                .blur(radius: 300)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, -200)
                .padding(.leading, -300)
                .opacity(dismissed ? 0.0 : 1.0)
                .animation(.easeOut, value: dismissed)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Circles(model: model, size: 72, width: 7.0, fill: true)
                    .padding(.bottom)
                
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
                
                let showRatingAt = [1, 6, 11, 16]
                Button {
                    dismiss()
                    dismissed.toggle()
                    
                    
                    if !ratedTheApp && showRatingAt.contains(flowsCompleted) && model.totalFlowTime > 600 {
                        requestReview()
                        flowsCompleted += 1
                    }
                    flowsCompleted += 1
                } label: {
                    Text("Dismiss")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.teal)
                        .cornerRadius(20)
                }
                
//                 only if completed, not reset
//                            Button {
//                
//                            } label: {
//                                Text("Extend last focus")
//                                    .font(.callout)
//                                    .fontWeight(.medium)
//                            }
//                            .padding(.vertical)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
        FlowCompletedView(model: FlowModel())
}
