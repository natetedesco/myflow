//
//  Flow.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation
import SwiftUI

struct Flow: Codable, Equatable, Identifiable {
    var id = UUID()
    var title: String = ""
    var blocks: [Block] = []
}

struct Block: Codable, Hashable, Identifiable {
    var id = UUID()
    var title: String = ""
    var tasks: [FocusTask] = []
    var tag: String = "Focus"
    var minutes: Int = 20
    var seconds: Int = 0
}

struct FocusTask: Codable, Hashable, Identifiable {
    var id = UUID()
    var title: String = ""
}

struct Day: Codable, Identifiable, Equatable {
    let day: Date
    var time: Int
    var today: Bool = false
    var id: Date { day }
}

extension Flow {
    func totalFlowTimeInSeconds() -> TimeInterval {
        var totalSeconds: TimeInterval = 0
        for block in blocks {
            totalSeconds += block.totalTimeInSeconds
        }
        return totalSeconds
    }
    
    func totalFlowTimeFormatted() -> String {
        let totalSeconds = totalFlowTimeInSeconds()
        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60

        var formattedTime = ""

        if hours > 0 {
            formattedTime += "\(hours) hr"
        }

        if minutes > 0 {
                if !formattedTime.isEmpty {
                formattedTime += ", "
            }
            formattedTime += "\(minutes) min"
        }

        if seconds > 0 {
            if !formattedTime.isEmpty {
                formattedTime += ", "
            }
            formattedTime += "\(seconds) sec"
        }
        
        if seconds == 0 && minutes == 0 && hours == 0 {
            formattedTime = "0 min"
        }

        return formattedTime
    }


}

extension Block {
    var totalTimeInSeconds: TimeInterval {
        let totalSeconds = TimeInterval(minutes * 60 + seconds)
        return totalSeconds
    }
}
