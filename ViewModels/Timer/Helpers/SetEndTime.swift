//
//  ElapsedTime.swift
//  MyFlow
//  Created by Nate Tedesco on 11/1/22.
//

import Foundation

extension FlowModel {
    
    func setEndTime(time: Int) -> Date {
        start = Date()
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .second, value: (time - elapsedTime), to: start)!
        
        return end
    }
}
