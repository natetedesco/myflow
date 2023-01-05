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
    @Binding var pickTime: Bool
    @FocusState var titleIsFocused: Bool
    
    var body: some View {
        let blockTime = [$block.minutes, $block.seconds]
        let extraSize: CGFloat = block.flow ? 150 : 175
        
        ZStack {
            Button {
                togglePickTime()
            } label: {
                VStack {}
                .frame(maxWidth: .infinity, minHeight: (block.flow ? 70 : 35) + (block.pickTime ? extraSize : 0))
                .background(block.flow ? Color.myBlue.opacity(0.15) : Color.gray.opacity(0.15))
                .cornerRadius(10)
                .background(blockSideBar)
            }
            VStack {
                HStack {
                    BlockTextField
                    BlockTimeLabel
                    DeleteButton
                }
                .padding(.horizontal)
                .padding(.top, block.pickTime ? 8 : 0)

                if block.pickTime {
                    MultiComponentPicker(columns: columns, selections: blockTime)
                }
            }
            .animation(.easeOut.speed(block.pickTime ? 1.0 : 2.0), value: block.pickTime) // make custom
        }
        .padding(.bottom, block.pickTime ? 4 : 0)
    }
    
    var blockSideBar: some View {
        RoundedRectangle(cornerRadius: 10)
        .fill(block.flow ? Color.myBlue.opacity(0.75) : Color.gray.opacity(0.75))
        .mask(
            HStack {
                Rectangle().frame(width: 6)
                Spacer()
            })
    }
    
    var BlockTextField: some View {
            TextField(block.flow ? "Flow" : "Break", text: $block.title)
                .font(.headline)
                .foregroundColor(block.flow ? .myBlue : .gray)
                .disabled(dragging)
                .frame(maxWidth: 100)
    }
    
    var BlockTimeLabel: some View {
        Text(formatTime(seconds: (block.seconds) + (block.minutes * 60)))
            .font(.subheadline)
            .foregroundColor(block.flow ? .myBlue : .gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder var DeleteButton: some View { // custom circle button
        if edit {
            Button {
                deleteBlock()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.leading)
            }
        }
    }
    
    func togglePickTime() {
        if !block.pickTime{
            flow.blocks.indices.forEach {
                flow.blocks[$0].pickTime = false
            }
        }
        block.pickTime.toggle()
        pickTime.toggle()
    }
    
    func deleteBlock() {
        flow.deleteBlock(id: block.id)
    }
}
