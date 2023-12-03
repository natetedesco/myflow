////
////  Drag & Drop.swift
////  MyFlow
////  Created by Nate Tedesco on 8/22/23.
////
//
//import SwiftUI
//
//// Drop Delegate
//struct DropViewDelegate: DropDelegate {
//    var model: FlowModel
//    var currentItem: Block
//    var items: Binding<[Block]>
//    var draggingItem: Binding<Block?>
//    @Binding var dragging: Bool
//    
//    func performDrop(info: DropInfo) -> Bool {
//        print("dragging off")
//        dragging = false
//        draggingItem.wrappedValue = nil
//        model.saveFlow()
//        return true
//    }
//    
//    func dropEntered(info: DropInfo) {
//        dragging = true
//        if currentItem.id != draggingItem.wrappedValue?.id {
//            let from = items.wrappedValue.firstIndex(of: draggingItem.wrappedValue!)!
//            let to = items.wrappedValue.firstIndex(of: currentItem)!
//            if items[to].id != draggingItem.wrappedValue?.id {
//                items.wrappedValue.move(fromOffsets: IndexSet(integer: from),
//                                        toOffset: to > from ? to + 1 : to)
//            }
//        }
//    }
//    func dropUpdated(info: DropInfo) -> DropProposal? {
//        return DropProposal(operation: .move)
//    }
//}
//
//// Draggable modifier
//struct Draggable: ViewModifier {
//    let condition: Bool
//    let data: () -> NSItemProvider
//    
//    @ViewBuilder
//    func body(content: Content) -> some View {
//        if condition {
//            content.onDrag(data)
//        } else {
//            content
//        }
//    }
//}
//
//extension View {
//    public func drag(if condition: Bool, data: @escaping () -> NSItemProvider) -> some View {
//        self.modifier(Draggable(condition: condition, data: data))
//    }
//}
//
//struct CornerShape: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//    var horizontalTrim: CGFloat = 16 // Amount to trim from the left and right sides
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        let adjustedWidth = rect.size.width - 2 * horizontalTrim
//
//        path.addRoundedRect(in: CGRect(x: horizontalTrim, y: rect.minY, width: adjustedWidth, height: rect.size.height), cornerSize: CGSize(width: radius, height: radius))
//
//        return path
//    }
//}
//
//extension View {
//    func customOnDrop(model: FlowModel, draggingItem: Binding<Block?>, items: Binding<[Block]>, dragging: Binding<Bool>) -> some View {
//        self.onDrop(of: [.item], delegate: DropViewDelegate(model: model, currentItem: draggingItem.wrappedValue ?? Block(), items: items, draggingItem: draggingItem, dragging: dragging))
//    }
//    
//    func dragAndDrop(model: FlowModel, block: Binding<Block>, draggingItem: Binding<Block?>, dragging: Binding<Bool>, blocks: Binding<[Block]>) -> some View {
//        self
//            .contentShape([.dragPreview], CornerShape(radius: 25, corners: [.allCorners]))
//            .opacity(block.wrappedValue.id == draggingItem.wrappedValue?.id && dragging.wrappedValue ? 0.001 : 1)
//            .drag(if: block.wrappedValue.draggable) {
//                heavyHaptic()
//                draggingItem.wrappedValue = block.wrappedValue
//                return NSItemProvider(contentsOf: URL(string: "\(block.wrappedValue.id)"))!
//            }
//            .onDrop(of: [.item], delegate: DropViewDelegate(model: model, currentItem: block.wrappedValue, items: blocks, draggingItem: draggingItem, dragging: dragging))
//    }
//}
//
