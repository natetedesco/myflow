//
//  SheetView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct FlowSheet: View {
    @ObservedObject var flowModel: FlowModel
    @State var flow: Flow
    @FocusState var focusedField: Field?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AnimatedBlur()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SheetCapsule()
                    
                    // Title and Save
                    HStack {
                        FlowTitle(flow: $flow, focusedField: _focusedField)
                        SaveButton(flowModel: flowModel, flow: $flow)
                    }.padding(.horizontal).padding(.bottom)
                
                    // Simple & Custom Flows
                    VStack( alignment: .leading) {
                        FlowModePicker(customFlow: $flow.customFlow)
                        if !flow.customFlow { SimpleFlow(flow: $flow) }
                        else { CustomFlow(flow: $flow) }
                    }
                    .modifier(CustomGlass())
                
                    // Goal & Reminder
                    VStack(alignment: .leading) {
                        Goal(flow: $flow)
                        Divider()
                        Reminder(flow: $flow)
                        if flow.reminder {
                            Divider()
//                            DayPicker(flow: $flow) // Fix later
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(CustomGlass())
                    
                    if !flow.new {
                        DeleteButton(flowModel: flowModel, flow: $flow)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.default, value: flow.customFlow)
        }
    }
}

struct Previews_FlowSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatedBlur()
            FlowSheet(flowModel: FlowModel(), flow: Flow())
        }
    }
}
