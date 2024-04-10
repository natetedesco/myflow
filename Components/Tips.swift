//
//  Tips.swift
//  MyFlow
//  Created by Developer on 4/10/24.
//

import SwiftUI
import TipKit

struct BlockControlTip: Tip {
    var title: Text {
        Text("Block Controls")
    }
    var message: Text? {
        Text("Swipe left to delete. Swipe Right to duplicate. Drag to rearange.")
        
    }
    var image: Image? {
        Image(systemName: "hand.draw")
    }
}

struct BlocksTip: Tip {
    var title: Text {
        Text("Add Focus Blocks")
    }
    var message: Text? {
        Text("Create a block for everything you want to focus on, then start your Flow.")
        
    }
    var image: Image? {
        Image(systemName: "rectangle.stack.badge.plus")
    }
}

struct CompleteTip: Tip {
    var title: Text {
        Text("Control Your Flow")
    }
    var message: Text? {
        Text("Start the next focus, take a break, swipe right to extend, or swipe left to reset.")
    }
    var image: Image? {
        Image(systemName: "circle")
    }
}
