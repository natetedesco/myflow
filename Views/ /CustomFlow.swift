//
//  CustomFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/18/22.
//

import SwiftUI

struct CustomFlow: View {
    @Binding var flow: Flow
    @State var draggingItem: Block?
    @State var dragging = false
    @State var edit = false
    @FocusState var focusedField: Field?
    
    var body: some View {
        VStack {
            
            // Blocks
            VStack {
                ForEach($flow.blocks) { $block in
                    FlowBlock(block: $block, flow: $flow, edit: $edit, dragging: $dragging)
                        .opacity(block.id == draggingItem?.id && dragging ? 0.01 : 1)
                        .drag(if: block.draggable) { draggingItem = block
                            return NSItemProvider(contentsOf: URL(string: "\(block.id)"))!}
                        .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: block, items: $flow.blocks, draggingItem: $draggingItem, dragging: $dragging))
                        .padding(.vertical, -1)
                }
            }
            .padding(.top, -8)
            .padding(.bottom, 8)
            
            // Edit
            HStack {
                Button(action: addFlowBlock) { AddButtonLabel(title: "Flow", color: .myBlue) }
                Spacer()
                EditButton
                Spacer()
                Button(action: addBreakBlock) { AddButtonLabel(title: "Break", color: .gray) }
            }
        }
        .animation(.easeOut.speed(1.0), value: edit) // adding blocks
    }
    
    func addFlowBlock() {
        mediumHaptic()
        flow.blocks.indices.forEach {
            flow.blocks[$0].pickTime = false
        }
        flow.addFlowBlock()
    }
    
    func addBreakBlock() {
        mediumHaptic()
        flow.blocks.indices.forEach {
            flow.blocks[$0].pickTime = false
        }
        flow.addBreakBlock()
    }
    
    var EditButton: some View {
        Button {
            flow.blocks.indices.forEach {
                flow.blocks[$0].pickTime = false
            }
            edit.toggle()
        }
    label: {
        Text(edit ? "Done" : "Edit")
            .myBlue()
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
        print("dragging off")
        dragging = false
        draggingItem.wrappedValue = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        print("dragging on")
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

//    func delete(at offsets: IndexSet) {
//        flow.blocks.remove(atOffsets: offsets)
//    }
