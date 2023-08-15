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
    @FocusState var focusedField: Field?
    
    var body: some View {
        let blockTime = [$block.minutes, $block.seconds]
        let blockSize: CGFloat = (block.flow ? 50 : 25) + (block.pickTime ? (block.flow ? 140 : 170) : 0)
        let blockColor = block.flow ? Color.myBlue.opacity(0.15) : Color.gray.opacity(0.15)
        
        ZStack {
            VStack{
                
//                if block.flow {
//                    VStack(spacing: 16) {
//                        BlockTextField
//                        Button(action: togglePickTime) {
//                            BlockTimeLabel
//                        }
//                    }
//                } else {
                    HStack {
                        BlockTextField
                        Button(action: togglePickTime) {
                            BlockTimeLabel
                        }
//                    }
                        DeleteButton
                            .padding(.top, block.pickTime ? block.flow ? 18 : 6 : 0)
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
                    Rectangle().frame(width: 5)
                    Spacer()
                })
    }
    
    var BlockTextField: some View {
        ZStack {
            TextField(block.flow ? "Focus" : "Break", text: $block.title)
                .font(block.flow ? .callout : .footnote)
                .fontWeight(.medium)
                .foregroundColor(block.flow ? .myBlue : .gray)
                .opacity(0.9)
                .disabled(dragging)
            //                .maxWidth()
                .focused($focusedField, equals: .blockName)
                .padding(.leading, 14)
            //                .padding(.top)
            //                .frame(maxHeight: .infinity, alignment: .top)
            
            // Solves keyboard glitch when selecting blockname after time
                .overlay {
                    Rectangle()
                        .foregroundColor(.white.opacity(0.0001))
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            flow.blocks.indices.forEach {
                                flow.blocks[$0].pickTime = false
                            }
                            focusedField = .blockName
                        }
                }
        }
    }
    
    var BlockTimeLabel: some View {
        Text(formatTime(seconds: (block.seconds) + (block.minutes * 60)))
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(block.flow ? .myBlue : .gray)
            .opacity(0.9)
//            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 12)
    }
    
    @ViewBuilder var DeleteButton: some View { // custom circle button
        if edit {
            Button {
                deleteBlock()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.trailing, 12)
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
    }
    
    func deleteBlock() {
        mediumHaptic()
        if !(flow.blocks.count == 1) {
            flow.deleteBlock(id: block.id)
        }
    }
}
