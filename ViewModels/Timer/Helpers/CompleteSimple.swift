//
//  CompleteSimple.swift
//  MyFlow
//  Created by Nate Tedesco on 11/25/22.
//

import Foundation

extension FlowModel {
    
    func completeSimple(flow: Bool) {
        if flow {
            completeFlow()
        }
        if !flow {
            completeBreak()
        }
    }
    
}
