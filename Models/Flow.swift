//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation
import SwiftUI
import CloudKit


struct Flow: Codable, Equatable {
    
    var id = UUID()
    var new = false
    var title: String = ""
    
    var simple = true
    var blocks = [
        Block(flow: true, title: "Brainstorm", seconds: 600),
        Block(flow: false, title: "Break", seconds: 300),
        Block(flow: true, title: "Creative Writing", seconds: 1200),
        Block(flow: false, title: "Break", seconds: 300)]
    
    var flowMinutes: Int = 0
    var flowSeconds: Int = 0
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    
    var rounds: Int = 0
}
