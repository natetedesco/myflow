//
//  GetElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func getElapsedTime() {
        // Gets time since start
        let newTime = Int(abs(start.timeIntervalSinceNow))
        
        // Adds total time from start
        elapsedTime = elapsedTime + newTime
    }
}
