//
//  SheetView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/15/22.
//

import SwiftUI

struct FlowSheet: View {
    @ObservedObject var flowModel: FlowModel
    @ObservedObject var reminders = Reminders()
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
                    }
                
                    // Simple & Custom Flows
                    VStack( alignment: .leading) {
                        FlowModePicker(simple: $flow.simple)
                        if flow.simple { SimpleFlow(flow: $flow) }
                        else { CustomFlow(flow: $flow) }
                    }
                    .modifier(CustomGlass())
                
                    // Goal & Reminder
                    VStack(alignment: .leading) {
                        Reminder(flow: $flow)
                        if flow.reminder {
                            Divider()
                            HStack(spacing: 16) {
                                ForEach(reminders.days) { day in
                                    DayButton(day: day.day, isOn: day.isOn)
                                }
                            }
                            .padding(.horizontal,8)
                        }
                    }
                    .modifier(CustomGlass())
                    
                    if !flow.new {
                        DeleteButton(flowModel: flowModel, flow: $flow)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.default, value: flow.simple)
        }
    }
}

struct FlowTitle: View {
    @Binding var flow: Flow
    @FocusState var focusedField: Field?
    
    var body: some View {
        TextField(flow.title, text: $flow.title)
            .font(.title)
            .foregroundColor(.gray)
            .focused($focusedField, equals: .flowname)
            .onAppear {
                if flow.new {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { focusedField = .flowname }
                }
            }
            .padding(.horizontal).padding(.bottom)
    }
}

struct SaveButton: View {
    @ObservedObject var flowModel: FlowModel
    @Binding var flow: Flow
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            dismiss()
            if flow.new {
                flowModel.addFlow(flow: flow)
            } else {
                flowModel.editFlow(id: flow.id, flow: flow)
            }
        } label: {
            Text("Save")
                .font(.subheadline)
                .foregroundColor(.myBlue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal).padding(.bottom)
        }
    }
}

struct Reminder: View {
    @Binding var flow: Flow
    
    var body: some View {
        HStack {
            Text("Reminder")
                .foregroundColor(.white)
            Text("5:00pm")
                .foregroundColor(.gray)
            Spacer()
            Toggle(isOn: $flow.reminder) {
            }.toggleStyle(SwitchToggleStyle(tint: Color.myBlue))
        }
    }
}

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
        }
    }
}

enum Field: Hashable {
    case flowname
}

struct Previews_FlowSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AnimatedBlur()
            FlowSheet(flowModel: FlowModel(), flow: Flow())
        }
    }
}
