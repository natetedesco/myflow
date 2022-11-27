//
//  FlowMenu.swift
//  MyFlow
//  Created by Nate Tedesco on 10/22/22.
//

import SwiftUI

struct FlowMenu: View {
    @ObservedObject var model: FlowModel
    @Binding var selectedFlow: Flow?
    
    var body: some View {
        Menu {
            
            // Create Flow
            Button(action: { self.selectedFlow = Flow(new: true)}) {
                Label("Create Flow", systemImage: "plus")
            }
            
            // Edit Flow
            Button(action: { self.selectedFlow = model.flowList[model.selection] }) {
                Label("Edit Flow", systemImage: "pencil")
            }
            
            // List
            Picker(selection: $model.selection) {
                ForEach(0..<self.$model.flowList.count, id: \.self) { index in
                    Text(model.flowList[index].title)
                }
            }label: {} // Unused
        }
    label: { // Menu Label
        Text(model.flowList[model.selection].title)
            .font(.title2)
            .fontWeight(.light)
            .accentColor(.myBlue)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(.ultraThinMaterial.opacity(0.55))
            .cornerRadius(30)
            .animation(.easeInOut(duration: 0.15), value: model.flowList)
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .padding(.top)
    }
}
