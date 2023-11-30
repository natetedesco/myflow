//
//  CreateFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI

struct CreateFlowView: View {
    @State var model: FlowModel
    
    @State var newFlowTitle = ""
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                VStack {
                    
                    Circles(model: model, size: 96, width: 12, fill: true)
                    
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
                        .onAppear {
                            isFocused = true
                        }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                        if !newFlowTitle.isEmpty {
                            model.createFlow(title: newFlowTitle == "" ? "Flow" : newFlowTitle)
                            newFlowTitle = ""
                            model.selection = model.flowList.count - 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                model.showFlow = true
                            }
                        }
                    } label : {
                        Text("Create")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.myColor)
                            .cornerRadius(8)
                            .padding(.vertical)
                    }
                }
                .padding(.horizontal)
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
