//
//  CreateFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI
import Introspect

struct CreateFlowView: View {
    @State var model: FlowModel
    
    @State var newFlowTitle = "New Flow"
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.black.opacity(0.3).ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Circles(model: model, size: 96, width: 10, fill: true)
                    
                    Spacer()
                    
                    Text("Create Flow")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    
                    TextField("Flow Title", text: $newFlowTitle)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.regularMaterial)
                        .cornerRadius(12)
                        .focused($isFocused)
                        .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                            }
                        }
                        .introspectTextField { textField in
                                    textField.becomeFirstResponder()
                                  }
                    
                    Button {
                        dismiss()
                        if !newFlowTitle.isEmpty {
                            model.createFlow(title: newFlowTitle == "" ? "Flow" : newFlowTitle)
                            newFlowTitle = ""
                        }
                        model.flow = model.flowList.last ?? Flow()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            model.showFlow = true
                        }
                    } label : {
                        Text("Create")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(8)
                            .padding(.vertical)
                    }
                }
                .padding(.horizontal, 24)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
        
    }
}

//#Preview {
//    CreateFlowView()
//}

