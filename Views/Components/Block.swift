//
//  Block.swift
//  MyFlow
//  Created by Nate Tedesco on 8/22/23.
//

import SwiftUI

struct BlockView: View {
    @State var model: FlowModel
    @Binding var block: Block

    var body: some View {
        HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(block.title.isEmpty ? "Focus" : block.title)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(block.title.isEmpty ? .secondary : .primary)
                        .multilineTextAlignment(.leading)

                    Text(timerLabel)
                        .font(.title3)
                        .fontWeight(.light)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                    Gauge(value: gaugeValue, label: {Text("")})
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(.accentColor)
                        .scaleEffect(0.9)
                        .animation(.default, value: gaugeValue)
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
        if model.mode != .initial && currentBlock {
            return formatTime(seconds: model.flowTimeLeft)
        } else {
            return formatTime(seconds: (block.seconds) + (block.minutes * 60) + (block.hours * 3600))
        }
    }
}
