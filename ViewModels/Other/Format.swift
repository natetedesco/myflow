//
//  Model Extension.swift
//  MyFlow
//  Created by Nate Tedesco on 6/18/22.
//

import SwiftUI

func formatTime(seconds: Int) -> String {
    let hours = seconds / 3600
    let remainingSeconds = seconds % 3600
    let minutes = remainingSeconds / 60
    let remainingSecondsAfterMinutes = remainingSeconds % 60
    
    let hourStamp = hours > 0 ? "\(hours):" : ""
    let minuteStamp = minutes > 9 ? "\(minutes):" : "0\(minutes):"
    let secondStamp = remainingSecondsAfterMinutes > 9 ? "\(remainingSecondsAfterMinutes)" : "0\(remainingSecondsAfterMinutes)"
    
    return hourStamp + minuteStamp + secondStamp
}



func formatHoursAndMinutes(time: Int) -> String {
    let hours = "\(time / 60)"
    let minutes = "\((time % 3600) % 60)"
    
    let hourStamp = hours.count >= 1 ? hours : "0"
    let minuteStamp = minutes.count >= 1 ? minutes : "0"
    return ("\(hourStamp)h \(minuteStamp)m")
}


func formatHours(time: Int) -> String {
    let hours = Double(time) / 60.0
    return String(format: "%.1fhr", hours)
}

func formatProgress(time: Int, timeLeft: Int) -> CGFloat {
    let progress = (CGFloat(time) - CGFloat(timeLeft)) / CGFloat(time)
    return(progress)
}

func format360(time: Int, timeLeft: Int) -> Int {
        let progress = Int(Double(time - timeLeft) / Double(time) * 360)
        return progress
    }
