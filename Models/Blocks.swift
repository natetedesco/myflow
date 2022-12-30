//
//  Blocks.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation

struct Block: Codable, Hashable, Identifiable {
    var id = UUID()
    var flow: Bool = true
    var title: String = ""

    var minutes = 0
    var seconds = 0
    
    var draggable = true
    var pickTime = false
}

extension Flow {
    mutating func addFlowBlock() {
        blocks.append(Block(flow: true))
    }
    
    mutating func addBreakBlock() {
        blocks.append(Block(flow: false))
    }
    
    mutating func deleteBlock(id: UUID) {
        if let index = blocks.firstIndex(where: { $0.id == id }) {
            blocks.remove(at: index)
        }
    }
}
