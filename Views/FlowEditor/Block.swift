//
//  Block.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockView: View {
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
    
    var body: some View {
        
        // Button Action
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
            
            // Button Label
            HStack() {
                Circle()
                    .foregroundColor(block.flow ? .myBlue : .gray)
                    .frame(height: 16)
                Text(block.title)
                    .font(block.flow ? .title : .body)
                    .padding(.leading, 8)
                
                Spacer()
                Text(formatTime(seconds: (block.seconds) + (block.minutes * 60) + (block.hours * 3600)))
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
            
            // Slide to Delete
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
                                    heavyHaptic()
                                }
                            }
                            
                            // User has gone back below -200, cancel delete
                            if isDeleting && translationX > -175 {
                                isDeleting = false
                                heavyHaptic()
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
