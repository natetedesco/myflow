//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import SwiftUI

struct Flow: Codable, Hashable, Identifiable {
    var id = UUID()
    var new = false
    
    var title: String = ""
    
    var simple = true
    var blocks = [Block(flow: true), Block(flow: false)]
    
    var flowMinuteSelection: Int = 0
    var flowSecondsSelection: Int = 0
    var breakMinuteSelection: Int = 0
    var breakSecondsSelection: Int = 0
    var roundsSelection: Int = 0
    
    var reminder: Bool = false
    var goal: Bool = false
    var reminderTime: Int = 0
    var goalTime: Int = 0
    
//    var days = Days() // Fix later
}
