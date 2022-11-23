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

func formatProgress(time: Int, timeLeft: Int) -> CGFloat {
    let progress = (CGFloat(time) - CGFloat(timeLeft)) / CGFloat(time)
    return(progress)
}
