//
//  FlowBlock.swift
//  MyFlow
//  Created by Nate Tedesco on 10/16/22.
//

import SwiftUI

struct FlowBlock: View {
    @Binding var block: Block
    @Binding var flow: Flow
    @Binding var edit: Bool
    @Binding var isDragging: Bool
    var minutes = [Int](0...60)
    var seconds = [Int](0...60)
    var columns = [
        MultiComponentPicker.Column(label: "min", options: Array(0...60).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
        MultiComponentPicker.Column(label: "sec", options: Array(0...59).map { MultiComponentPicker.Column.Option(text: "\($0)", tag: $0) }),
    ]
    
    var body: some View {
        VStack {
            HStack {
                
                // Delete Minus Button
                if edit {
                    Button { flow.deleteBlock(id: block.id) }
                    label: { DeleteMinus }
                }
                
                // Title
                BlockTextField
                
                // Time
                Button { block.draggable.toggle(); block.pickTime.toggle() }
                label: { BlockTimeLabel }
            }
            .animation(.default, value: edit).animation(.default, value: block) // make custom
            .frame(maxWidth: .infinity, minHeight: block.flow == true ? 60 : 30)
            
            // Time Picker
            if block.pickTime {
                MultiComponentPicker(columns: columns, selections: [$block.minuteSelection, $block.secondSelection]).frame(height: 150).previewLayout(.sizeThatFits)
            }
        }
        .background(block.flow == true ? Color.myBlue.opacity(0.2) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .background(RoundedRectangle(cornerRadius: 10)
        .fill(block.flow == true ? Color.myBlue : Color.gray)
        .mask(HStack { Rectangle().frame(width: 6); Spacer()}))
        .padding(.vertical, 1)
    }
    
    var DeleteMinus: some View {
        Image(systemName: "minus.circle.fill")
            .font(.headline)
            .foregroundColor(.red)
            .padding(.leading)
    }
    
    var BlockTextField: some View {
        TextField("Title", text: $block.title)
            .foregroundColor(block.flow == true ? .myBlue : .gray)
            .font(.callout)
            .padding(.leading)
            .disabled(isDragging)
    }
    
    var BlockTimeLabel: some View {
        Text(formatTime(seconds: (block.secondSelection) + (block.minuteSelection * 60)))
            .foregroundColor(block.flow == true ? .myBlue : .gray)
            .font(.footnote)
            .padding(.trailing)
    }
}

