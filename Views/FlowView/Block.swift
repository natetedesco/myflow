//
//  Block.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockView: View {
    @ObservedObject var model: FlowModel
    @Binding var flow: Flow
    @State var index: Int
    
    @Binding var block: Block
    @Binding var selectedBlock: Bool
    @Binding var showBlockEditor: Bool
    @Binding var selectedIndex: Int
    
    @State private var isDeleting = false
    @State private var xOffset: CGFloat = 0
    @State private var deleteIconOpacity: Double = 0 // New state for delete icon opacity
    @State private var isSliding = false
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        
        // Button Action

                // Button Label
                HStack() {
                    Circle()
                        .foregroundColor(block.flow ? .myColor : .gray)
                        .frame(height: 16)
                    Text(block.title)
                        .font(block.flow ? .title2 : .body)
                        .fontWeight(.medium)
                        .padding(.leading, 8)
                        .foregroundStyle(.ultraThickMaterial)
                        .environment(\.colorScheme, .light)
                    
                    Spacer()
                    Text(formatTime(seconds: (block.seconds) + (block.minutes * 60) + (block.hours * 3600)))
                        .foregroundStyle(.thinMaterial)
                        .environment(\.colorScheme, .light)
                }
            
        
//        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: selectedBlock ? 256 : block.flow ? 80 : 40)
        .padding(.horizontal, 16)
        .background(.black.opacity(block.flow ? 0.5 : 0.25))
        .background(block.flow ? .regularMaterial : .ultraThinMaterial)
        .cornerRadius(24)
        .padding(.horizontal, 16)
        
        // Slide to Delete
        .offset(x: xOffset)
        .overlay(
            GeometryReader { geometry in
                Image(systemName: "trash")
                    .opacity(deleteIconOpacity)
                    .animation(isSliding ? .default : .none, value: deleteIconOpacity)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundColor(isDeleting ? .red : .gray)
                    .offset(x: xOffset + geometry.size.width) // Offset by block width
            }
        )
        .background(
            GeometryReader { geometry in
                // Check if the user is dragging
                if xOffset < 0 {
                    Color.black.opacity(0.001)
                        .background(.ultraThinMaterial)
                        .frame(width: max(-xOffset, 0), height: geometry.size.height) // Adjust the width based on xOffset
                        .cornerRadius(25)
                        .offset(x: max(xOffset + geometry.size.width, 0)) // Animate the offset for sliding in from the right
                        .padding(.leading, -16)
                }
            }
        )
        .gesture(
            withAnimation {
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < -20 { // prevents block from moving, fixes stuck when scrolling
                            let translationX = value.translation.width
                            
                            if translationX < -10 {
                                deleteIconOpacity = 1
                                
                                if translationX < -175 && isDeleting == false {
                                    isDeleting = true
                                    deleteIconOpacity = 1
                                    softHaptic()
                                }
                            }
                            
                            // User has gone back below -200, cancel delete
                            if isDeleting && translationX > -175 {
                                isDeleting = false
                                softHaptic()
                            }
                            
                            xOffset = translationX
                            isSliding = true
                        }
                    }
                    .onEnded { value in
                        isSliding = false
                        deleteIconOpacity = 0
                        
                        if isDeleting {
                            xOffset = -175
                            deleteBlock()
                        }
                        else {
                            xOffset = 0
                        }
                        isDeleting = false
                    }
            }
        )
    }
    
    func deleteBlock() {
        softHaptic()
        if !(flow.blocks.count == 1) {
            flow.deleteBlock(id: block.id)
        }
    }
    
}

//struct Block_Previews: PreviewProvider {
//    static var previews: some View {
//        BlockView()
//    }
//}
