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
    
    @Binding var pickTime: Bool
    
    var body: some View {
        VStack {
            
            // Flow Blocks
            VStack {
                ForEach($flow.blocks) { $block in
                    FlowBlock(block: $block, flow: $flow, edit: $edit, dragging: $dragging, pickTime: $pickTime)
                    .opacity(block.id == draggingItem?.id && dragging ? 0.01 : 1)
                    .drag(if: block.draggable) { draggingItem = block
                        return NSItemProvider(contentsOf: URL(string: "\(block.id)"))!}
                    .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: block, items: $flow.blocks, draggingItem: $draggingItem, dragging: $dragging))
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
        .animation(.easeOut.speed(1.0), value: edit) // adding blocks
        .animation(.easeOut.speed(1.5), value: pickTime) // make custom
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
        Button {
            edit.toggle()
        }
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
                .CircularGlassButton()
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