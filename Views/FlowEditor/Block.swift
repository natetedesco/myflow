//
//  Block.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockView: View {
    @Binding var flow: Flow
    @Binding var block: Block
    @State var index: Int
    
    @Binding var selectedBlock: Bool
    @Binding var showBlockEditor: Bool

    @Binding var selectedIndex: Int
    
    @State private var isDeleting = false
    @State private var xOffset: CGFloat = 0 // New state for X offset
    @State private var deleteIconOpacity: Double = 0 // New state for delete icon opacity
    @State private var isDragging = false // Track if the user is dragging the block
    
    var body: some View {
        Button {
            if let selectedBlockIndex = flow.blocks.firstIndex(where: { $0.id == block.id }) {
                selectedBlock = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    showBlockEditor = true
                                }
                selectedIndex = selectedBlockIndex
                mediumHaptic()
            }
        } label: {
            HStack() {
                Circle()
                    .foregroundColor(block.flow ? .myBlue : .gray)
                    .frame(height: 16)
                Text(block.title)
                    .font(block.flow ? .title : .body)
                    .padding(.leading, 8)
                
                Spacer()
                Text(formatTime(seconds: (block.seconds) + (block.minutes * 60)))
                    .font(.body)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: block.flow ? 96 : 48)
            .padding(.horizontal, 16)
            .background(block.flow ? .black.opacity(0.75) : .black.opacity(0.5))
            .background(.ultraThinMaterial)
            .cornerRadius(25)
            .padding(.horizontal)
            .offset(x: xOffset) // Apply the X offset here
            .overlay(
                GeometryReader { geometry in
                    Image(systemName: "trash")
                        .frame(maxHeight: .infinity, alignment: .center)
                        .font(.title2)
                        .foregroundColor(.gray)
                        .opacity(deleteIconOpacity)
                        .offset(x: xOffset + geometry.size.width + 16) // Offset by block width
                }
            )
            .background(
                GeometryReader { geometry in
                    // Check if the user is dragging
                    if xOffset < 0 {
                        Color.black.opacity(0.001)
                            .background(.ultraThinMaterial)// You can change this to any color you like
                            .frame(width: max(-xOffset, 0), height: geometry.size.height) // Adjust the width based on xOffset
                            .cornerRadius(25)
                            .offset(x: max(xOffset + geometry.size.width, 0)) // Animate the offset for sliding in from the right
                            .padding(.leading, -16)
                    }
                }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translationX = value.translation.width
                        
                        if translationX < -20 {
                            withAnimation {
                                deleteIconOpacity = 1
                            }
                            if translationX < -200 {
                                isDeleting = true
                                withAnimation {
                                    deleteIconOpacity = 1
                                }
                            }
                        } else if translationX > 20 && isDeleting {
                            // User has swiped back to the right, cancel delete
                            isDeleting = false
                            
                            withAnimation {
                                deleteIconOpacity = 0
                            }
                        }
                        
                        if isDeleting && translationX > -200 {
                            // User has gone back below -200, cancel delete
                            isDeleting = false
                            
                            withAnimation {
                                deleteIconOpacity = 0
                            }
                        }
                        
                        xOffset = translationX
                        isDragging = true
                    }
                    .onEnded { value in
                        isDragging = false
                        
                        if isDeleting {
                            withAnimation {
                                xOffset = -200
                                deleteIconOpacity = 0
                            }
                            //                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            deleteBlock()
                            //                                    }
                        } else {
                            withAnimation {
                                xOffset = 0
                            }
                        }
                        isDeleting = false
                    }
            )
        }
    }
    
    func deleteBlock() {
        mediumHaptic()
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
