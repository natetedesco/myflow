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
            
            VStack {
                Circles(model: model, size: 160, width: 16.0, fill: true)
                    .padding(.top)
                
                Spacer()
                
                Text("Flow Completed")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack {
                    Text("Total FlowTime: ")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .fontWeight(.medium)
                    Text(formatHoursAndMinutes(time: model.totalFlowTime/60))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.myColor)
                }
                .padding(.bottom, 32)
            }
        }
        .padding(.top, 32)
        .padding(.horizontal)
    }
}

//#Preview {
//    ShowFlowCompletedView()
//}
