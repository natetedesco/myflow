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
        Text("Swipe left to delete. Swipe right to duplicate. Drag and drop to reorder.")
        
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
        Text("Create focus blocks for all of your tasks, your flow will start from the first block.")
        
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
        Text("Start the next focus, take a break, or extend your focus by swiping right on it.")
    }
    var image: Image? {
        Image(systemName: "circle")
    }
}
