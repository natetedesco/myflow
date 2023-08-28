//
//  Model Extension.swift
//  MyFlow
//  Created by Nate Tedesco on 6/18/22.
//

import SwiftUI

func formatTime(seconds: Int) -> String {
    let minutes = "\(seconds / 60)"
    let seconds = "\((seconds % 3600) % 60)"
    
    let minuteStamp = minutes.count > 1 ? minutes : minutes
    let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
    
    return ("\(minuteStamp):\(secondStamp)")
}

func formatHoursAndMinutes(time: Int) -> String {
    let hours = "\(time / 60)"
    let minutes = "\((time % 3600) % 60)"
    
    let hourStamp = hours.count >= 1 ? hours : "0"
    let minuteStamp = minutes.count >= 1 ? minutes : "0"
    return ("\(hourStamp)h \(minuteStamp)m")
}

func formatProgress(time: Int, timeLeft: Int) -> CGFloat {
    let progress = (CGFloat(time) - CGFloat(timeLeft)) / CGFloat(time)
    return(progress)
}
