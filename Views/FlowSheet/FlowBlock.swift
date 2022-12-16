//
//  FlowBlock.swift
//  MyFlow
//  Created by Nate Tedesco on 10/16/22.
//

import SwiftUI

struct FlowBlock: View {
    @Binding var block: Block
    @Binding var flow: Flow
    
    @State var deleting = false
    @Binding var edit: Bool
    @Binding var isDragging: Bool
    
    var body: some View {
        VStack {
            HStack {
                
                // Delete minus
                if edit {
                    Button {
                        deleting.toggle()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                }
                
                // Title
                TextField("Title", text: $block.title)
                    .foregroundColor(block.flow == true ? .myBlue : .gray)
                    .font(.callout)
                    .padding(.leading)
                    .disabled(isDragging)
                
                // Time
                Button {
                    block.draggable.toggle();
                    block.pickTime.toggle()
                } label: {
//                    Text(block.flow == true ? "Time" : "Time")
                    Text(formatTime(seconds: block.timeSelection))
                        .foregroundColor(block.flow == true ? .myBlue : .gray)
                        .font(.footnote)
                        .padding(.trailing)
                }
                
                // Delete Button
                if deleting {
                    Button {
                        deleting.toggle();
                        flow.deleteBlock(id: block.id)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.white)
                            .frame(maxHeight: .infinity)
                            .padding(.horizontal)
                            .background(.red)
                    }
                }
            }
            .animation(.default, value: deleting)
            .animation(.default, value: edit)
            .animation(.default, value: block)
            .frame(maxWidth: .infinity, minHeight: block.flow == true ? 60 : 30)
            
            // Time Picker
            if block.pickTime {
                PickerView(selection: $block.timeSelection, unit: block.time, label: "time")
                    .frame(maxWidth: 200, maxHeight: block.flow == true ? 150 : 180)
            }
            
        }
        .background(block.flow == true ? Color.myBlue.opacity(0.2) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(block.flow == true ? Color.myBlue : Color.gray)
                .mask(
                    HStack {
                        Rectangle().frame(width: 6)
                        Spacer()
                    }))
        .padding(.vertical, 1)
    }
}

