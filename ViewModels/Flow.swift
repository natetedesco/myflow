//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation
import SwiftUI

struct Flow: Codable, Equatable {
    var id = UUID()
    var new = false
    var title: String = ""
    
    var pickTime = false

    var blocks = [Block(flow: true, title: "Focus", minutes: 20),
                  Block(flow: false, title: "Break", minutes: 5)]
    
    var selectedBlock = Block()

}

struct Block: Codable, Hashable, Identifiable {
    
    var id = UUID()
    var flow: Bool = true
    var title: String = ""

    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    var draggable = true
    var pickTime = false
}

extension Flow {
    mutating func addFlowBlock() {
        blocks.append(Block(flow: true, minutes: 20))
    }
    
    mutating func addBreakBlock() {
        blocks.append(Block(flow: false, minutes: 5))
    }
    
    mutating func deleteBlock(id: UUID) {
        if let index = blocks.firstIndex(where: { $0.id == id }) {
            blocks.remove(at: index)
        }
    }
}


