//
//  SettingNotification.swift
//  MyFlow
//  Created by Nate Tedesco on 1/24/23.
//

import Foundation

extension FlowModel {
    
    func setNotification(flow: Bool, time: Int, id: String = "timer") {
        notifications.Set(flow: flow, time: time, elapsed: elapsed, id: id)
    }
}
