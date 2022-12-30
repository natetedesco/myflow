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
    
    var flowMinutes: Int = 0
    var flowSeconds: Int = 0
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    
    var rounds: Int = 0
}
