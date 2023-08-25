//
//  BlockEditor.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockEditingView: View {
    @ObservedObject var model: FlowModel
    @Binding var flow: Flow
    @Binding var index: Int
    
    @Binding var selectedBlock: Bool
    @Binding var showBlockEditor: Bool
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        
        VStack {
            HStack {
                Circle()
                    .foregroundColor(flow.blocks[index].flow ? .myBlue : .gray)
                    .frame(height: 16)
                TextField(flow.blocks[index].flow ? "Focus" : "Break", text: $flow.blocks[index].title)
                    .focused($focusedField, equals: .blockName)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .onAppear {
                        focusedField = .blockName
                    }
                    .font(.title)
                    .padding(.leading, 8)
                    .submitLabel(.done)
                    .onSubmit {
                        if flow.blocks[index].title.isEmpty {
                            flow.blocks[index].title = flow.blocks[index].flow ? "Focus" : "Break"
                        }
                        model.save()
                        selectedBlock = false
                        showBlockEditor = false
                    }
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top)
        
            Divider()
            MultiComponentPicker(columns: columns, selections: [$flow.blocks[index].hours, $flow.blocks[index].minutes, $flow.blocks[index].seconds])
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
        .background(flow.blocks[index].flow ? .black.opacity(0.75) : .black.opacity(0.5))
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .padding()
        
    }
}
