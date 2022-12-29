//
//  CustomFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/18/22.
//

// replace edit with done when editing

import SwiftUI

struct CustomFlow: View {
    @Binding var flow: Flow
    @State var draggingItem: Block?
    @State var dragging = false // disables all textfields
    @State var edit = false
    
    var body: some View {
        VStack {
            
            // Flow Blocks
            VStack {
                ForEach(0..<self.$flow.blocks.count, id: \.self) { index in
                    FlowBlock(block: $flow.blocks[index], flow: $flow, edit: $edit, dragging: $dragging
                    )
                    .opacity(flow.blocks[index].id == draggingItem?.id && dragging ? 0.01 : 1)
                    .drag(if: flow.blocks[index].draggable) {
                        draggingItem = flow.blocks[index]
                        return NSItemProvider(contentsOf: URL(string: "\(flow.blocks[index].id)"))!
                    }
                    .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: flow.blocks[index], items: $flow.blocks, draggingItem: $draggingItem, dragging: $dragging))
                }
            }
            .padding(.bottom)
            
            // Edit Buttons
            HStack {
                Button(action: addFlowBlock) { AddButtonLabel(title: "Flow", color: .myBlue) }
                Spacer()
                EditButton
                Spacer()
                Button(action: addBreakBlock) { AddButtonLabel(title: "Break", color: .gray) }
            }
        }
        .animation(.easeInOut, value: flow.blocks) // adding blocks
        .animation(.default, value: edit) // editing blocks
    }
    
    func addFlowBlock() {
        flow.addFlowBlock()
    }
    
    func addBreakBlock() {
        flow.addBreakBlock()
    }
    
    func delete(at offsets: IndexSet) {
        flow.blocks.remove(atOffsets: offsets)
    }
    
    var EditButton: some View {
        Button { edit.toggle() }
        label: {
            Text(edit ? "Done" : "Edit")
                .foregroundColor(.myBlue)
        }
    }
}

struct AddButtonLabel: View {
    var title: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .font(.title3)
                .padding(12)
                .background(Circle().fill(.ultraThinMaterial.opacity(0.6)))
        }
        .foregroundColor(color)
    }
}

// Drop Delegate
struct DropViewDelegate: DropDelegate {
    var currentItem: Block
    var items: Binding<[Block]>
    var draggingItem: Binding<Block?>
    @Binding var dragging: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        dragging = false
        draggingItem.wrappedValue = nil // <- HERE
        return true
    }
    
    func dropEntered(info: DropInfo) {
        dragging = true
        
        if currentItem.id != draggingItem.wrappedValue?.id {
            let from = items.wrappedValue.firstIndex(of: draggingItem.wrappedValue!)!
            let to = items.wrappedValue.firstIndex(of: currentItem)!
            if items[to].id != draggingItem.wrappedValue?.id {
                items.wrappedValue.move(fromOffsets: IndexSet(integer: from),
                                        toOffset: to > from ? to + 1 : to)
            }
        }
    }
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

// Draggable modifier
struct Draggable: ViewModifier {
    let condition: Bool
    let data: () -> NSItemProvider
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if condition {
            content.onDrag(data)
        } else {
            content
        }
    }
}

extension View {
    public func drag(if condition: Bool, data: @escaping () -> NSItemProvider) -> some View {
        self.modifier(Draggable(condition: condition, data: data))
    }
}
