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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                    Gauge(value: gaugeValue, label: {Text("")})
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(.accentColor)
                        .scaleEffect(sizeClass == .regular ? 1.3 : 0.9)
                        .animation(.default, value: gaugeValue)
                        .padding(.leading, -2)
                
                Text(block.title.isEmpty ? "Focus" : block.title)
                    .font(sizeClass == .regular ? .largeTitle : .title3)
                    .fontWeight(.medium)
                    .foregroundStyle(focusLabelStyle)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    if model.flowExtended && currentBlock {
                        Image(systemName: "plus")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    
                    Text(timerLabel)
                        .font(sizeClass == .regular ? .title : .title3)
                        .fontWeight(.light)
                        .monospacedDigit()
                        .foregroundStyle(timerLabelStyle)
                }
            }
            if block.tasks.count > 0 {
                VStack(alignment: .leading) {
                    ForEach(block.tasks) { task in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundStyle(.tertiary)
                                .font(.title3)
                            Text(task.title)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .padding(.leading, 62)
                        .padding(.bottom, 2)
                    }
                }
                .padding(.top, -20)
                .padding(.bottom, 6)
            }
        }
        .contextMenu {
            if model.mode == .initial {
                Button {
                    model.duplicateBlock(block: block)
                } label: {
                    Text("Duplicate")
                }
                
                Button(role: .destructive) {
                    model.deleteBlock(id: block.id)
                } label: {
                    Text("Delete")
                }
            } else if model.mode == .flowRunning || model.mode == .flowPaused {
                Button {
                    model.Complete()
                } label: {
                    Text("Complete")
                }
            } else if model.mode == .flowStart {
                Button {
                    model.extend()
                } label: {
                    Text("Extend")
                }
            }
        }
    }
    
    var focusLabelStyle: any ShapeStyle {
        if block.title.isEmpty {
            return .tertiary
        }
        else if model.mode == .initial || completed {
            return .primary
        }
        return .tertiary
    }
    
    var timerLabelStyle: any ShapeStyle {
        if block.totalTimeInSeconds == 0 {
            return .red.secondary
        }
        if model.mode == .initial || completed {
            return .secondary
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
        else if model.flowExtended && currentBlock {
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
        if model.mode != .initial && currentBlock {
            return formatTime(seconds: model.flowTimeLeft)
        } else {
            return formatTimeNoZero(seconds: (block.seconds) + (block.minutes * 60))
        }
    }
}

#Preview {
    VStack {
        BlockView(model: FlowModel(), block: .constant(Block()))
        Divider()
        BlockView(model: FlowModel(), block: .constant(Block(title: "Break")))
        Divider()
        BlockView(model: FlowModel(), block: .constant(Block()))
        Divider()
    }
    .padding(.horizontal)
}
