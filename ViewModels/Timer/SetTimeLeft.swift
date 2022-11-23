//
//  SetTimeLeft.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    func setTimeLeft(flow: Bool, end: Date) -> Int {
        let timeLeft = Calendar.current.dateComponents([.second], from: Date(), to: end + 1).second ?? 0
        self.animate = animate + 1
        
        if flow {
            flowTimeLeft = timeLeft
        }
        if !flow {
            breakTimeLeft = timeLeft
        }
        return timeLeft
    }
}
