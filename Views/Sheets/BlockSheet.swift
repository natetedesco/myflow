//
//  BlockSheet.swift
//  MyFlow
//  Created by Nate Tedesco on 12/1/23.
//

import SwiftUI
import Introspect

struct BlockSheetView: View {
    @State var model: FlowModel
    
    @Binding var newBlock: Bool
    
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    @State private var isFocusSelected = true
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack {
                VStack {
                    TextField("Block Title", text: $model.flow.blocks[model.selectedIndex].title)
                        .leading()
                        .focused($isFocused)
                        .onSubmit {
                            model.saveFlow()
                            dismiss()
                            newBlock = false
                        }

                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                        .introspectTextField { textField in textField.becomeFirstResponder() }
//                    
//                    Divider()
//                    
//                    Text("Subtasks")
//                        .foregroundStyle(.secondary)
//                        .padding(.vertical, 2)
//                        .leading()
//                    
//                    Divider()
//                    
//                    Text("Tag")
//                        .foregroundStyle(.secondary)
//                        .padding(.vertical, 2)
//                        .leading()

                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .cornerRadius(16)

                
                MultiComponentPicker(columns: columns, selections: [
                    $model.flow.blocks[model.selectedIndex].minutes,
                    $model.flow.blocks[model.selectedIndex].seconds]
                )
                .padding(.vertical, -12)
                
                Button {
                    model.saveFlow()
                    dismiss()
                    newBlock = false
                } label : {
                    Text(newBlock ? "Add Block" : "Save")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.teal)
                        .cornerRadius(16)
                        .padding(.bottom)
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

#Preview {
    FlowView(model: FlowModel())
        .sheet(isPresented: .constant(true), content: {
            BlockSheetView(model: FlowModel(), newBlock: .constant(false))
                .sheetMaterial()
                .presentationDetents([.fraction(1/3)])
                .presentationBackgroundInteraction(.enabled)
        })
}
