//
//  CreateFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/30/23.
//

import SwiftUI
import Introspect

struct CreateFlowView: View {
    @State var model: FlowModel
    @Binding var showFlow: Bool
    
    @State var newFlowTitle = ""
    @FocusState var isFocused
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.black.opacity(0.1).ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    Circles(model: model, size: 80, width: 8, fill: true)
//                        .padding(.top)
                    Spacer()
                    
                    TextField("New Flow", text: $newFlowTitle)
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
//                        .padding(.leading)
                        .focused($isFocused)
//                        .onSubmit { submit() }
                        .introspectTextField { textField in textField.becomeFirstResponder() }
                    
//                     Future
//                    Spacer()
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Text("Focus")
//                                .fontWeight(.medium)
//                            Spacer()
//                            Text("All")
//                                .foregroundStyle(.tertiary)
//                        }
//                        .padding(.top, 4)
//                        .padding(.bottom, 8)
//                        
//                        Divider()
//                            .padding(.horizontal, -16)
//                        HStack {
//                            Text("Breaks")
//                                .fontWeight(.medium)
//                            Spacer ()
//                            Text("None")
//                                .foregroundStyle(.tertiary)
//                        }
//                        .padding(.bottom, 8)
//                        .padding(.top, 8)
//                        
//                        Divider()
//                            .padding(.horizontal, -16)
//                        HStack {
//                            Text("Schedule")
//                                .fontWeight(.medium)
//                            Spacer()
//                            Text("None")
//                                .foregroundStyle(.tertiary)
//                        }
//                        .padding(.bottom, 4)
//                        .padding(.top, 8)
//
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                        .background(.black.opacity(0.3))
//                        .cornerRadius(24)
//                        .padding(.bottom, 8)
                    
                    Spacer()
                    
                    Button {
                        submit()
                    } label : {
                        Text("Create Flow")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(16)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.tertiary)
                            .padding(8)
                            .background(Circle().foregroundStyle(.bar))
                    }
                    .padding(.top, 12)
                }
            }
        }
        
    }
    
    func submit() {
        lightHaptic()
        dismiss()
            model.createFlow(title: newFlowTitle == "" ? "Flow" : newFlowTitle)
            newFlowTitle = ""
        model.flow = model.flowList.last ?? Flow()
        
        
        showFlow.toggle()
    }
}

#Preview {
    ZStack {
        
    }
    .sheet(isPresented: .constant(true), content: {
        CreateFlowView(model: FlowModel(), showFlow: .constant(true))  
            .presentationBackground(.regularMaterial)
            .presentationCornerRadius(40)
    })
}
