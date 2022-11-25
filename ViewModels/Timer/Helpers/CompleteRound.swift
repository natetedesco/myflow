//
//  Custom.swift
//  MyFlow
//  Created by Nate Tedesco on 11/7/22.
//

import Foundation

extension FlowModel {
    
    func completeRound() -> Bool {
        updateRounds()
        
        if roundsCompleted == flowList[selection].roundsSelection {
            setValues()
            completed = true
            return true
        }
        return false
    }
}
