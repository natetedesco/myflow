//
//  Checkers.swift
//  MyFlow
//  Created by Nate Tedesco on 1/23/23.
//

import Foundation

extension FlowModel {
    
    func isFlow() -> Bool {
        if type == .Flow {
            return true
        }
        return false
    }
    
    func isBreak() -> Bool {
        if type == .Break {
            return true
        }
        return false
    }
    
    func Simple() -> Bool {
        if flowMode == .Simple {
            return true
        }
        return false
    }
    
    func Custom() -> Bool {
        if flowMode == .Custom {
            return true
        }
        return false
    }
    
    func flowRunning() -> Bool {
        if mode == .flowRunning {
            return true
        }
        return false
    }
    
    func breakRunning() -> Bool {
        if mode == .breakRunning {
            return true
        }
        return false
    }
 
    func flowPaused() -> Bool {
        if mode == .flowPaused {
            return true
        }
        return false
    }
    
    func breakPaused() -> Bool {
        if mode == .breakPaused {
            return true
        }
        return false 
    }
    
    func flowStart() -> Bool {
        if mode == .flowStart {
            return true
        }
        return false
    }
    
    func breakStart() -> Bool {
        if mode == .breakStart {
            return true
        }
        return false
    }
    
}
