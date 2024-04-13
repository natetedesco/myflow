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
    
    @State var title = ""
    @State var minutes = 20
    @State var seconds = 0
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("Focus", text: $title)
                    .font(title.count > 22 ? .title3 : .title)
                    .animation(.default, value: title)
                    .fontWeight(.semibold)
                    .focused($isFocused)
                    .onSubmit { submit() }
                    .padding(.leading, 8).padding(.top, 4)
                    .multilineTextAlignment(.leading)
                    .introspectTextField { textField in textField.becomeFirstResponder() }
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textField = obj.object as? UITextField {
                            if !newBlock {
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                    }
                
                Spacer()
                
                Button {
                    dismiss()
                    newBlock = false
                } label: {
                    Image(systemName: "xmark")
                        .fontWeight(.bold)
                        .foregroundStyle(.white.tertiary)
                        .padding(8)
                        .background(Circle().foregroundStyle(.bar))
                        .padding(.trailing, 4)
                }
            }
            
            Spacer()
            
            MultiComponentPicker(columns: columns, selections: [$minutes, $seconds])
            
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("Time")
//                    Spacer()
//                    Text("All")
//                        .foregroundStyle(.tertiary)
//                }
//                .padding(.top, 4)
//                .padding(.bottom, 8)
//                
//                Divider()
//                    .padding(.horizontal, -16)
//                HStack {
//                    Text("Tasks")
//                    Spacer()
//                    Text("None")
//                        .foregroundStyle(.tertiary)
//                }
//                .padding(.bottom, 4)
//                .padding(.top, 8)
//
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding()
//                .background(.black.opacity(0.3))
//                .cornerRadius(24)
            
            Spacer()
            
            // Save Button
            Button {
                submit()
            } label : {
                Text(newBlock ? "Add Focus" : "Save")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.teal)
                    .cornerRadius(16)
            }
        }
        .padding()
    }
    
    @Environment(\.dismiss) var dismiss
    
    func submit() {
        if title.isEmpty {
            title = "Focus"
        }
        if newBlock {
            model.addBlock(title: title, minutes: minutes, seconds: seconds)
        } else {
            model.updateBlock(title: title, minutes: minutes, seconds: seconds)
        }
        lightHaptic()
        model.saveFlow()
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            newBlock = false
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
