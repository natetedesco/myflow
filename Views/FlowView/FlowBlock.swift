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
        let blockTime = [$block.minutes, $block.seconds]
        
        ZStack {
            
            Button {
                selectTime()
            } label: {
                VStack {
            
                }
                .frame(maxWidth: .infinity, minHeight: (block.flow ? 70 : 35) + (block.pickTime ? 150 : 0))
                .background(block.flow ? Color.myBlue.opacity(0.15) : Color.gray.opacity(0.15))
                .cornerRadius(10)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(block.flow ? Color.myBlue.opacity(0.75) : Color.gray.opacity(0.75))
                    .mask(HStack { Rectangle().frame(width: 6); Spacer()}))
            }
            
            VStack {
                HStack {
                    BlockTextField
                    
                    BlockTimeLabel

                    DeleteButton
                }
                if block.pickTime {
                    MultiComponentPicker(columns: columns, selections: blockTime)
                }
            }
        }
        .animation(.easeInOut.speed(0.1), value: block.pickTime) // make custom
    }
    
    // stuck on these animations
    
    var BlockTextField: some View {
            TextField(block.flow ? "Flow" : "Break", text: $block.title)
                .font(.headline)
                .foregroundColor(block.flow ? .myBlue : .gray)
                .padding(.leading)
                .disabled(dragging)
    }
    
    var BlockTimeLabel: some View {
        Text(formatTime(seconds: (block.seconds) + (block.minutes * 60)))
            .font(.callout)
            .foregroundColor(block.flow ? .myBlue : .gray)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder var DeleteButton: some View { // custom circle button
        if edit {
            Button {
                deleteBlock()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.trailing)
                    .padding(.vertical, 8)
            }
        }
    }
    
    func deleteBlock() {
        flow.deleteBlock(id: block.id)
    }
    
    func selectTime() {
        block.draggable.toggle()
        block.pickTime.toggle()
    }
}

