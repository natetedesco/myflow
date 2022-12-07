//
//  FlowData.swift
//  MyFlow
//  Created by Nate Tedesco on 12/2/22.
//

import Foundation
import SwiftUI

struct Day: Identifiable {
    let day: Date
    let flowTime = 0
    var id: Date { day }
}

class FlowData: ObservableObject {
    
    
    var presentedDays: [Day] { getLastSevenDays() }
    
    let days: [Day] = [
        Day(day: Date.from(day: 0))

    ]
    
    func getLastSevenDays() -> [Day] {
        
        return []
    }
}

extension Date {
    static func from(day: Int) -> Date {
        
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        
        return Calendar.current.date(byAdding: .day, value: day, to: Date())!
    }
}

