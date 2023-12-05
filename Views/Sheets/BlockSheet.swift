//
//  BlockSheet.swift
//  MyFlow
//  Created by Nate Tedesco on 12/1/23.
//

import SwiftUI
import Introspect

struct BlockSheetView: View {
    @State var model: FlowModel
    
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
                VStack {
                    HStack {
                        TextField("Block Title", text: $model.flow.blocks[model.selectedIndex].title)
                            .leading()
                            .focused($isFocused)
                            .onSubmit {
                                model.saveFlow()
                                model.newBlock = false
                                dismiss()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                                            if let textField = obj.object as? UITextField {
                                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                                            }
                                        }
                            .introspectTextField { textField in
                                        textField.becomeFirstResponder()
                                      }
                        
                        Button {
                            model.saveFlow()
//                            if model.newBlock {
//                                model.flow.blocks.removeLast()
//                            }
                            model.newBlock = false
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .foregroundStyle(.white.secondary)
                                .padding(12)
                                .background(Circle().foregroundStyle(.ultraThinMaterial))
                        }
                    }
                    
                    MultiComponentPicker(columns: columns, selections: [
                        $model.flow.blocks[model.selectedIndex].hours,
                        $model.flow.blocks[model.selectedIndex].minutes,
                        $model.flow.blocks[model.selectedIndex].seconds]
                    )
                    .padding(.vertical, -12)
                    
                    Button {
                        model.saveFlow()
                        model.newBlock = false
                        dismiss()
                    } label : {
                        Text(model.newBlock ? "Add Block" : "Save")
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

//#Preview {
//    BlockSheet()
//}
