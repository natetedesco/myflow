//
//  BlockEditor.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockEditingView: View {
    @ObservedObject var model: FlowModel
    @Binding var flow: Flow
    @Binding var block: Block
    @Binding var index: Int
    
    @Binding var selectedBlock: Bool
    @Binding var showBlockEditor: Bool
    
    @FocusState var focusedField: Field?
    
    
    var body: some View {
        
        VStack {
            HStack {
                Circle()
                    .foregroundColor(block.flow ? .myColor : .gray)
                    .frame(height: 16)
                TextField(block.flow ? "Focus" : "Break", text: $block.title)
                    .focused($focusedField, equals: .blockName)
                    .onAppear {
                        focusedField = .blockName
                    }
                    .font(.title)
                    .padding(.leading, 8)
                    .submitLabel(.done)
                    .onSubmit {
                        if block.title.isEmpty {
                            block.title = block.flow ? "Focus" : "Break"
                        }
                        model.save()
                        selectedBlock = false
                        showBlockEditor = false
                    }
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(formatTime(seconds: (block.seconds) + (block.minutes * 60) + (block.hours * 3600)))
            }
            .padding(.top)
            
            Divider()
            HStack {
                MultiComponentPicker(columns: columns, selections: [$block.hours, $block.minutes, $block.seconds])
                
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
        .background(block.flow ? .black.opacity(0.75) : .black.opacity(0.5))
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .padding()
    }
}
