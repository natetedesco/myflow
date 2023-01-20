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
    var simple = true
    
    var flowMinutes: Int = 0
    var flowSeconds: Int = 0
    var breakMinutes: Int = 0
    var breakSeconds: Int = 0
    var rounds: Int = 0
    
    var blocks = [Block(flow: true), Block(flow: false)]
}
