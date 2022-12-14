//
//  Data.swift
//  MyFlow
//  Created by Nate Tedesco on 12/13/22.
//

import Foundation

extension FlowData {
    
    func getDayOfTheWeek() -> Int {
        var day = calendar.component(.weekday, from: date)
        if day != 1 {
            day = day - 1
        }
        else if day == 1 {
            day = 7
        }
        day = day - 1
        
        return day
    }
}
