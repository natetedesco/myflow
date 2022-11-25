//
//  CompleteRound.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func completeRound() -> Bool {
        self.roundsCompleted = roundsCompleted + 1
        self.roundsRemaining = roundsRemaining - 1
        
        if roundsCompleted == flowList[selection].roundsSelection {
            return true
        }
        return false
    }
    
}
