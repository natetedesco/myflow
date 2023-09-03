//
//  FlowCompleted.swift
//  MyFlow
//  Created by Nate Tedesco on 1/19/23.
//

import SwiftUI

struct FlowCompleted: View {
    @ObservedObject var model: FlowModel
    @Binding var show: Bool

    var body: some View {
        ZStack {
//            MaterialBackGround()
//                .opacity(show ? 1.0 : 0.0)
//                .animation(.default.speed(show ? 2.0 : 1.0), value: show)
            
            VStack(alignment: .center, spacing: 16) {
                Text("\(model.flow.title) Completed")
                    .font(.title2)
                HStack {
                    Text("Total flow time: ")
                        .font(.footnote)
                    Text(formatHoursAndMinutes(time: model.totalTime/60))
                        .foregroundColor(.myColor)
                        .font(.subheadline)
                }
            }
            .maxWidth()
            .padding(24)
            .background(.black.opacity(0.7))
            .cornerRadius(40)
            .padding(.horizontal, 48)
            .opacity(show ? 1.0 : 0.0)
            .scaleEffect(show ? 1.0 : 0.97)
            .animation(.default.speed(show ? 1.0 : 2.0), value: show)
            .animation(.default.speed(show ? 1.0 : 2.0), value: model.flowContinue)
        }
        .onTapGesture { model.dismissCompleted() }
    }
}

struct FlowCompleted_Previews: PreviewProvider {
    @State static var model = FlowModel()
    static var previews: some View {
        ZStack {
            FlowView(model: model)
            FlowCompleted(model: model, show: .constant(true))
        }
    }
}
