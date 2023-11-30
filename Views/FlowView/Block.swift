//
//  Block.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockView: View {
    @Bindable var model: FlowModel
    @Binding var block: Block
    
    @State var showCompleteBlock = false
    
    @FocusState var focusedBlockID: UUID?
    @FocusState var focusedTaskIndex: Int?

    
    var body: some View {
        
        Button {
            if model.mode == .initial {
                if let selectedBlockIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                    focusedBlockID = block.id
                    model.selectedIndex = selectedBlockIndex
                    model.blockSelected = true
                }
            }
        } label: {
            
            HStack {
                
                VStack(alignment: .leading) {
//                    FocusTitle
                    Text(block.title)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

//                        .onAppear {
//                            if block.title.isEmpty {
//                                if let selectedBlockIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
//                                    focusedBlockID = block.id
//                                    model.selectedIndex = selectedBlockIndex
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                        model.blockSelected = true
//                                    }
//                                }
//                            }
//                        }
                    Text(timerLabel)
                        .font(.title)
                        .fontWeight(.thin)
                        .monospacedDigit()
                        .foregroundStyle(.white.secondary)
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.bottom, -8)
                
                Spacer()
                
                ZStack {
                    Gauge(value: gaugeValue, label: {Text("")})
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(.accentColor)
                        .scaleEffect(0.9)
                        .padding(.trailing, 4)
                        .animation(.default, value: gaugeValue)
                    
//                    if gaugeValue != 1.0 && gaugeValue != 0 {
//                        Image(systemName: "pause.fill")
//                            .padding(.trailing, 4)
//                    }

                    
                }
                
                

            }
            .leading()
            .padding(.horizontal)
            
            // Slide to Delete
            .offset(x: xOffset)
            .overlay(
                GeometryReader { geometry in
                    Image(systemName: "trash")
                        .opacity(deleteIconOpacity)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .font(.title2)
                        .foregroundColor(isDeleting ? .red : .gray)
                        .animation(isSliding ? .default : .none, value: deleteIconOpacity)
                        .offset(x: xOffset + geometry.size.width) // Offset by block width
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
                                    if translationX < -250 && isDeleting == false {
                                        isDeleting = true
                                        deleteIconOpacity = 1
                                        lightHaptic()
                                    }
                                }
                                
                                // User has gone back below -200, cancel delete
                                if isDeleting && translationX > -250 {
                                    isDeleting = false
                                    lightHaptic()
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
                                model.deleteBlock(id: block.id)
                                model.blockSelected = false
                            }
                            else {
                                xOffset = 0
                            }
                            isDeleting = false
                        }
                }
            )
        }
        .confirmationDialog("", isPresented: $showCompleteBlock) {  // Delete Flow Alert
            Button("Cancel", role: .cancel) { }
            Button("Complete") {
                model.Skip()
            }
        }
    }
    
    var FocusTitle: some View {
        TextField("Focus", text: $block.title)
//            .disabled(model.dragging || model.mode != .initial)
//            .focused($focusedBlockID, equals: block.id)
            .disabled(model.dragging)
            .onSubmit {
                model.blockSelected = false
//                if !block.title.isEmpty {
//                    if let lastBlock = model.flow.blocks.last {
//                        model.addBlock()
//                        focusedBlockID = lastBlock.id
//                    }
//                } else {
//                    model.blockSelected = false
//                }
                if block.title.isEmpty {
                    block.title = "Focus"
//                    focusedTaskIndex = block.tasks.count
                }
                model.saveFlow()
            }
    }
    
    var currentBlock: Bool {
        if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
            return block == model.blocksCompleted
        }
        return false
    }
    
    var gaugeValue: CGFloat {
        if model.mode == .initial {
            return 1.0
        }
        else if currentBlock {
            return formatProgress(time: model.flowTime, timeLeft: model.flowTimeLeft)
        }
        else if let selectedBlockIndex = model.flow.blocks.firstIndex(where: { $0.id == block.id }), selectedBlockIndex < model.blocksCompleted {
            return 1.0
        }
        return 0.0
    }
    
    var timerLabel: String {
        if currentBlock {
            return formatTime(seconds: model.flowTimeLeft)
        } else {
            return formatTime(seconds: (block.seconds) + (block.minutes * 60) + (block.hours * 3600))
        }
    }
    
    // Slide to Delete
    @State var isDeleting = false
    @State var xOffset: CGFloat = 0
    @State var deleteIconOpacity: Double = 0
    @State var isSliding = false
    
    @State var showTasks = true
    @State var newTask = ""
}

