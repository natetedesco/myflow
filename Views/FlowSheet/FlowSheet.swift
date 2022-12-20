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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SheetCapsule
                
                // Title and Save
                HStack {
                    FlowTitle
                    SaveButton
                }
                
                // Simple & Custom Flows
                VStack( alignment: .leading) {
                    FlowModePicker
                    FlowEditor
                }
                .modifier(CustomGlass())
                
                // Reminder
                VStack(alignment: .leading) {
                    Reminder
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
                DeleteButton
            }
        }
//        .background(AnimatedBlur())
//        .background(.ultraThinMaterial)

        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(.default, value: flow.simple)
    }
    
    var SheetCapsule: some View {
        Capsule()
            .fill(Color.secondary)
            .opacity(0.5)
            .frame(width: 35, height: 5)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var FlowTitle: some View {
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
    
    var SaveButton: some View {
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
    
        var FlowModePicker: some View {
            Picker("", selection: $flow.simple, content: {
                Text("Simple").tag(true)
                Text("Custom").tag(false)
            })
            .pickerStyle(SegmentedPickerStyle())
            .preferredColorScheme(.dark)
            .padding(.bottom)
        }
    
    var Reminder: some View {
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
    
    @ViewBuilder var DeleteButton: some View {
        if !flow.new {
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
    
    @ViewBuilder var FlowEditor: some View {
        if flow.simple {
            SimpleFlow(flow: $flow)
        }
        else {
            CustomFlow(flow: $flow)
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
