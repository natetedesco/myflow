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
    
    @State var newTask = ""
    
    var block: Binding<Block> {
        return $model.flow.blocks[model.selectedIndex]
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()
                
                VStack {
                    TextField("Focus", text: block.title)
                        .font(model.flow.blocks[model.selectedIndex].title.count > 26 ? .title3 : .title)
                        .animation(.default, value: model.flow.blocks[model.selectedIndex].title)
                        .fontWeight(.semibold)
                        .focused($isFocused)
                        .onSubmit { submit() }
//                        .padding(.bottom, -8)
                        .padding(.leading, 8).padding(.top, 4)
                        .multilineTextAlignment(.leading)
                        .introspectTextField { textField in textField.becomeFirstResponder() }
                    
//                    Divider()
//                        .padding(.leading, 8)
//                        .padding(.top, 2)
                    
                    Spacer()
                    
                    MultiComponentPicker(columns: columns, selections: [block.minutes, block.seconds])
                    
                    Spacer()
                    
//                            VStack {
//                            
//                            if block.tasks.count == 0 {
//                                TextField("Task", text: $newTask)
//                                    .onSubmit {
//                                        model.flow.blocks[model.selectedIndex].tasks.append(FocusTask(title: newTask))
//                                        newTask = ""
//                                    }
//                            } else {
//                                ForEach(block.tasks) { $task in
//                                    HStack {
//                                        Image(systemName: "circle")
//                                            .foregroundStyle(.secondary)
//                                        TextField("Task", text: $task.title)
//                                            .onSubmit {
//                                                if task.title.isEmpty {
//                                                    model.flow.blocks[model.selectedIndex].tasks.removeLast()
//                                                    dismiss()
//                                                } else {
//                                                    model.flow.blocks[model.selectedIndex].tasks.append(FocusTask(title: ""))
//                                                }
//                                            }
//                                    }
//                                    if model.flow.blocks[model.selectedIndex].tasks.count > 1 && task != model.flow.blocks[model.selectedIndex].tasks.last {
//                                        Divider().padding(.vertical, 4)
//                                    }
//                                }
//                            }
//                        }
//                    .leading()
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 10)
//                    .background(.regularMaterial)
//                    .cornerRadius(16)
//
//                    Spacer()
                    
                    // Save Button
                    Button {
                        submit()
                    } label : {
                        Text(newBlock ? "Add Block" : "Save")
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
        }
    }
    
    func submit() {
        if model.flow.blocks[model.selectedIndex].title.isEmpty {
            model.flow.blocks[model.selectedIndex].title = "Focus"
        }
        model.saveFlow()
        dismiss()
        newBlock = false
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
