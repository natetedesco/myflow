//
//  Block.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockView: View {
    @State var model: FlowModel
    @Binding var block: Block
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State var showTasks = false
    
    var body: some View {
        HStack {
            
            Gauge(value: gaugeValue, label: {Text("")})
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(.accentColor)
                .scaleEffect(sizeClass == .regular ? 1.3 : 0.9)
                .animation(.default, value: gaugeValue)
//                    .padding(.trailing, -4)
                .padding(.leading, -2)
                .onTapGesture {
                    showTasks.toggle()
                }
            
            VStack(alignment: .leading) {
                Text(block.title.isEmpty ? "Focus" : block.title)
                    .font(sizeClass == .regular ? .largeTitle : .body)
                    .fontWeight(.medium)
                    .foregroundStyle(focusLabelStyle)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                
                if showTasks {
                                    Text(block.title.isEmpty ? "Focus" : block.title)
                                        .font(sizeClass == .regular ? .largeTitle : .callout)
                                        .foregroundStyle(.secondary)
                                        .foregroundStyle(focusLabelStyle)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .padding(.leading, 24)
                                        .padding(.top, 2)
                                    
                                    Text(block.title.isEmpty ? "Focus" : block.title)
                                        .font(sizeClass == .regular ? .largeTitle : .callout)
                                        .foregroundStyle(.secondary)
                                        .foregroundStyle(focusLabelStyle)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .padding(.leading, 24)
                                        .padding(.top, 2)
                                    
                                    Text(block.title.isEmpty ? "Focus" : block.title)
                                        .font(sizeClass == .regular ? .largeTitle : .callout)
                                        .foregroundStyle(.secondary)
                                        .foregroundStyle(focusLabelStyle)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .padding(.leading, 24)
                                        .padding(.top, 2)
                }
                
            }
                
                Spacer()
                

                
                HStack {
                    if model.flowExtended && currentBlock {
                        Image(systemName: "plus")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .padding(.trailing, -4)
                    }
                    
                    Text(timerLabel)
                        .font(sizeClass == .regular ? .title : .title2)
                        .fontWeight(.light)
                        .monospacedDigit()
                        .foregroundStyle(timerLabelStyle)
                }
                

            

        }
    }
    
    var focusLabelStyle: any ShapeStyle {
        if block.title.isEmpty {
            return .tertiary
        }
        else if model.mode == .initial || completed {
            return .primary
            //        } else if nextUp {
            //            return .teal.secondary
        }
        return .tertiary
    }
    
    var timerLabelStyle: any ShapeStyle {
        if model.mode == .initial || completed {
            return .secondary
            //        } else if nextUp {
            //            return .teal.secondary
        }
        return .tertiary
    }
    
    var showExtend: Bool {
        if model.mode == .flowStart {
            if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                return block == model.blocksCompleted - 1
            }
        }
        return false
    }
    
    var previousBlock: Bool {
        if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
            return block == model.blocksCompleted - 1
        }
        return false
    }
    
    var currentBlock: Bool {
        if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
            return block == model.blocksCompleted
        }
        return false
    }
    
    var nextUp: Bool {
        if model.mode == .flowStart {
            if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                return block == model.blocksCompleted
            }
        }
        return false
    }
    
    var completed: Bool {
        if model.mode == .flowRunning {
            if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
                return block <= model.blocksCompleted
            }
        } else if let block = model.flow.blocks.firstIndex(where: { $0.id == block.id }) {
            return block < model.blocksCompleted
        }
        return false
    }
    
    var gaugeValue: CGFloat {
        if model.mode == .initial {
            return 1.0
        }
        else if model.flowExtended && !currentBlock {
            return 0.0
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
        if model.mode != .initial && currentBlock {
            return formatTime(seconds: model.flowTimeLeft)
        } else {
            return formatTimeNoZero(seconds: (block.seconds) + (block.minutes * 60))
        }
    }
}

#Preview {
    List {
        BlockView(model: FlowModel(), block: .constant(Block()))
        BlockView(model: FlowModel(), block: .constant(Block(title: "Break")))
        BlockView(model: FlowModel(), block: .constant(Block()))
    }.listStyle(.plain)
}
