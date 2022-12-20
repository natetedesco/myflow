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
        if model.mode != .breakStart && !model.flowContinue {
            Menu {
                // Create Flow
                Button { selectedFlow = Flow(new: true) }
                label: { Label("Create", systemImage: "plus") }
                
                // Edit Flow
                Button { selectedFlow = model.flowList[model.selection] }
                label: { Label("Edit", systemImage: "pencil") }
                
                // List
                Picker(selection: $model.selection) {
                    ForEach(0..<$model.flowList.count, id: \.self) { index in
                        Text(model.flowList[index].title)
                    }
                }label:{} // Unused
            }
        label: { MenuLabel }
        }
    }
    
    var MenuLabel: some View {
        Text(model.flowList[model.selection].title)
            .font(.title2)
            .fontWeight(.light)
            .accentColor(.myBlue)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(.ultraThinMaterial.opacity(0.6))
            .cornerRadius(30)
            .animation(.easeInOut(duration: 0.15), value: model.flowList)
    }
}
