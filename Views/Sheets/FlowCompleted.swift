//
//  FlowCompleted.swift
//  MyFlow
//
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI

struct ShowFlowCompletedView: View {
    @State var model: FlowModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack {
                Circles(model: model, size: 128, width: 14.0, fill: true)
                    .padding(.vertical, 32)
                
                
                Text("Flow Completed")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                
                HStack {
                    Text("Total FlowTime: ")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .fontWeight(.medium)
                    Text(formatHoursAndMinutes(time: model.totalFlowTime/60))
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Extend")
                        .font(.callout)
                }
                
                Spacer()
                
                Button {
                    
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

//#Preview {
//    ShowFlowCompletedView()
//}
