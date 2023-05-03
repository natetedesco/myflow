//
//  SettingNotification.swift
//  MyFlow
//  Created by Nate Tedesco on 1/24/23.
//

import Foundation

extension FlowModel {
    
    func setSimpleNotification(flow: Bool, time: Int) {
        var extraTime = 0
        if flow && settings.startFlowAutomatically && settings.startBreakAutomatically {
            for i in 1...roundsSet {
                setNotification(flow: true, time: time + extraTime, id: "\(i)1")
                if i != roundsSet {
                    setNotification(flow: false, time: (time + flowTime) + extraTime, id: "\(i)2")
                }
                extraTime = extraTime + flowTime + breakTime
            }
        }
        
        else if flow {
            setNotification(flow: flow, time: time)
            if settings.startBreakAutomatically {
                setNotification(flow: false, time: time + breakTime, id: "2")
            }
        }

        else if !flow {
            setNotification(flow: flow, time: time)
            if settings.startFlowAutomatically {
                setNotification(flow: true, time: time + flowTime, id: "2")
            }
        }
    }
    
    func setNotification(flow: Bool, time: Int, id: String = "timer") {
        notifications.Set(flow: flow, time: time, elapsed: elapsed, id: id)
    }
}
