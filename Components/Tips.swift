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
        Text("Swipe left to delete. Swipe right to duplicate. Drag to rearange.")
        
    }
    var image: Image? {
        Image(systemName: "hand.draw")
    }
}

struct BlocksTip: Tip {
    var title: Text {
        Text("Focus Blocks")
    }
    var message: Text? {
        Text("Add Focus Blocks for each of your tasks, when you are done, start your Flow.")
        
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
        Text("Choose to take a break, start the next focus, or extend by swiping right.")
    }
    var image: Image? {
        Image(systemName: "circle")
    }
}
