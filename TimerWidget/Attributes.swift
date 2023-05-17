//
//  Attributes.swift
//  MyFlow
//  Created by Nate Tedesco on 5/2/23.
//

import Foundation
import ActivityKit

struct TimerWidgetAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var flow: Bool
        var custom: Bool = false
        var name: String
        var blockName: String
        
        var value: ClosedRange<Date>
        var paused: Bool = false
        
        var time: Int = 0
        var start: Date = Date()
        var extend: Bool = false
        
        var rounds: Int
        var roundsCompleted: Int
        
        var blocks: Int
        var blocksCompleted: Int
    }
    var name: String
}
