//
//  Complete.swift
//  MyFlow
//  Created by Nate Tedesco on 11/3/22.
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
    
    func completeSimple(flow: Bool) {
        if flow {
            mode = completeRound() ? .Initial : .breakStart
        }
        if !flow {
            setTimes()
            mode = .flowStart
        }
    }
}
