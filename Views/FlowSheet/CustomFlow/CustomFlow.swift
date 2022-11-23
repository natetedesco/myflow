//
//  CustomFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/18/22.
//

import SwiftUI

struct CustomFlow: View {
    @Binding var flow: Flow
    
    @State var draggingItem: Block?
    @State var isDragging = false // disables all textfields
    @State var edit = false
    
    var body: some View {
        VStack {
            
            // Done Button
            if edit {
                Button {
                    edit = false
                } label: {
                    Text("Done")
                        .foregroundColor(.myBlue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom)
                }
            }
            
            // Flow Blocks
            VStack {
                ForEach(0..<self.$flow.blocks.count, id: \.self) { index in
                    FlowBlock(
                        block: $flow.blocks[index],
                        flow: $flow,
                        edit: $edit,
                        isDragging: $isDragging
                    )
                    .mySwipeAction { flow.deleteBlock(id: $flow.blocks[index].id) }
                    .opacity(flow.blocks[index].id == draggingItem?.id && isDragging ? 0.01 : 1)
                    .drag(if: flow.blocks[index].draggable) {
                        draggingItem = flow.blocks[index]
                        return NSItemProvider(contentsOf: URL(string: "\(flow.blocks[index].id)"))!
                    }
                    .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: flow.blocks[index], items: $flow.blocks, draggingItem: $draggingItem, isDragging: $isDragging))
                }
            }
            .padding(.bottom, 15) // 1 from block
            
            // Add Flow Button
            HStack {
                Button { flow.addFlowBlock() }
                    label: { AddButtonLabel(title: "Flow", color: .myBlue) }
                
                Spacer()
                
                // Edit Button
                Menu {
                    Button { edit.toggle() }
                        label: { Text("Edit") }
                    
                    Button { }
                        label: { Text("Default values") }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.myBlue)
                        .font(.title2)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Add Break Button
                Button { flow.addBreakBlock() }
                    label: { AddButtonLabel(title: "Break", color: .gray) }
            }
        }
        .animation(.easeInOut, value: flow.blocks) // adding blocks
        .animation(.default, value: edit) // editing blocks
    }
    func delete(at offsets: IndexSet) {
        flow.blocks.remove(atOffsets: offsets)
    }
}

// Drop Delegate
struct DropViewDelegate: DropDelegate {
    var currentItem: Block
    var items: Binding<[Block]>
    var draggingItem: Binding<Block?>
    @Binding var isDragging: Bool
    
    func performDrop(info: DropInfo) -> Bool {
        isDragging = false
        
        draggingItem.wrappedValue = nil // <- HERE
        return true
    }
    
    func dropEntered(info: DropInfo) {
        isDragging = true
        
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

