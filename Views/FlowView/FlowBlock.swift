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
    @Binding var dragging: Bool
    
    var body: some View {
        VStack {
            
            // Block
            HStack {
                if edit { Button(action: deleteBlock) { DeleteMinus } }
                
                BlockTextField
                
                Button(action: selectTime) { BlockTimeLabel }
            }
            .animation(.default, value: edit).animation(.default, value: block) // make custom
            .frame(maxWidth: .infinity, minHeight: block.flow ? 60 : 30)
            
            // Time Picker
            if block.pickTime {
                MultiComponentPicker(
                    columns: columns,
                    selections: [$block.minutes, $block.seconds])
                .frame(height: 150).previewLayout(.sizeThatFits)
            }
        }
        .background(block.flow ? Color.myBlue.opacity(0.2) : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .background(RoundedRectangle(cornerRadius: 10)
        .fill(block.flow ? Color.myBlue : Color.gray)
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
        TextField(block.flow ? "Flow" : "Break", text: $block.title)
            .foregroundColor(block.flow ? .myBlue : .gray)
            .padding(.leading)
            .disabled(dragging)
    }
    
    var BlockTimeLabel: some View {
        FootNote(text: formatTime(seconds: (block.seconds) + (block.minutes * 60)))
            .foregroundColor(block.flow ? .myBlue : .gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
    
    func deleteBlock() {
        flow.deleteBlock(id: block.id)
    }
    
    func selectTime() {
        block.draggable.toggle()
        block.pickTime.toggle()
    }
}

