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
    @FocusState var titleIsFocused: Bool
    
    var body: some View {
        let blockTime = [$block.minutes, $block.seconds]
        let blockSize: CGFloat = (block.flow ? 70 : 35) + (block.pickTime ? (block.flow ? 150 : 175) : 0)
        let blockColor = block.flow ? Color.myBlue.opacity(0.15) : Color.gray.opacity(0.15)
        
        ZStack {
            VStack{
                HStack {
                    BlockTextField
                    Button(action: togglePickTime) {
                        BlockTimeLabel
                    }
                    DeleteButton
                }
                if block.pickTime {
                    MultiComponentPicker(columns: columns, selections: blockTime)
                        .padding(.leading, 6)
                }
            }
            .animation(.easeOut.speed(block.pickTime ? 0.6 : 2.0), value: block.pickTime)
        }
        .frame(maxWidth: .infinity, minHeight: blockSize)
        .background(blockColor)
        .cornerRadius(10)
        .background(blockSideBar)
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
            .foregroundColor(block.flow ? .myBlue : .gray)
            .disabled(dragging)
            .frame(maxWidth: 100)
            .padding(.leading, 18)
    }
    
    var BlockTimeLabel: some View {
        Text(formatTime(seconds: (block.seconds) + (block.minutes * 60)))
            .font(.callout)
            .foregroundColor(block.flow ? .myBlue : .gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing)
    }
    
    @ViewBuilder var DeleteButton: some View { // custom circle button
        if edit {
            Button {
                deleteBlock()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.trailing)
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
        //        pickTime.toggle()
    }
    
    func deleteBlock() {
        flow.deleteBlock(id: block.id)
    }
}
