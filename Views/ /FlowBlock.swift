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
    @State var pickTime = false
    @FocusState var focusedField: Field?
    
    var body: some View {
        let blockTime = [$block.minutes, $block.seconds]
        let blockSize: CGFloat = (block.flow ? 64 : 32) + (block.pickTime ? (block.flow ? 140 : 170) : 0)
        
        ZStack {
            VStack{
                HStack {
                    BlockTextField
                    Button(action: togglePickTime) {
                        BlockTimeLabel
                    }
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
        //        .background(block.flow ? Color.myBlue.opacity(0.10) : Color.gray.opacity(0.10))
//        .background(.ultraThinMaterial)
        .background(block.flow
                    ?
                    LinearGradient(
                        gradient: Gradient(colors: [.myBlue.opacity(0.15), .myBlue.opacity(0.075)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    :
                        LinearGradient(
                            gradient: Gradient(colors: [.gray.opacity(0.15), .gray.opacity(0.075)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
        )
        .background(.ultraThinMaterial.opacity(0.2))
        .cornerRadius(12.5)
        .background(blockSideBar)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                TextField(block.flow ? "Focus" : "Break", text: $block.title)
                    .focused($focusedField, equals: .blockName)
                    .foregroundColor(.white.opacity(0.9))
                    .submitLabel(.done)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
            }
            
        }
    }
    
    var blockSideBar: some View {
        RoundedRectangle(cornerRadius: 12.5)
            .fill(block.flow ? Color.myBlue.opacity(0.9) : Color.gray.opacity(0.9))
            .mask(
                HStack {
                    Rectangle().frame(width: 8)
                        .cornerRadius(12.5)
//                                            .padding(6)
                    Spacer()
                })
    }
    
    var BlockTextField: some View {
        ZStack {
            TextField(block.flow ? "Focus" : "Break", text: $block.title)
                .font(block.flow ? .body : .footnote)
//                .foregroundColor(block.flow ? .myBlue : .gray)
                .foregroundColor(.white.opacity(0.9))
                .disabled(dragging || flow.pickTime)
                .focused($focusedField, equals: .blockName)
                .padding(.leading, 16)
                .padding(.top, block.pickTime ? block.flow ? 18 : 0 : 0)
                .submitLabel(.done)
                .keyboardType(.alphabet)
                            .disableAutocorrection(true)               .onTapGesture {
                    flow.blocks.indices.forEach {
                        flow.blocks[$0].pickTime = false
                    }
                    focusedField = .blockName
                }
        }
    }
    
    
    var BlockTimeLabel: some View {
        Text(formatTime(seconds: (block.seconds) + (block.minutes * 60)))
            .font(.caption)
            .fontWeight(.medium)
//            .foregroundColor(block.flow ? .myBlue : .gray)
            .foregroundColor(.white.opacity(0.6))

            .padding(.trailing, 12)
            .padding(.top, block.pickTime ? 16 : 0)
        
        //            .onTapGesture {
        //                focusedField = nil
        //            }
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
        focusedField = nil
        
    }
    
    func deleteBlock() {
        mediumHaptic()
        if !(flow.blocks.count == 1) {
            flow.deleteBlock(id: block.id)
        }
    }
}


