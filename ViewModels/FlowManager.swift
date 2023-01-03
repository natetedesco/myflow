//
//  FlowManager.swift
//  MyFlow
//  Created by Nate Tedesco on 10/18/22.
//

import Foundation
import CloudKit

class TimerManager: ObservableObject {
    var data = FlowData()
    var settings = Settings()
    var notifications = NotificationManager()
    
    var start = Date()
    var timer = Timer()
    @Published var flow = Flow()
    
    @Published var flowTime: Int = 0
    @Published var flowTimeLeft: Int = 0
    
    @Published var breakTime: Int = 0
    @Published var breakTimeLeft: Int = 0
    
    @Published var roundsSet: Int = 0
    @Published var roundsCompleted: Int = 0
    @Published var blocksCompleted: Int = 0
    
    @Published var elapsedTime = 0
    @Published var totalFlowTime: Int = 0
    @Published var flowContinue = false
    @Published var completed = false
    @Published var showFlow = false
    
    @Published var mode: TimerMode = .Initial
    @Published var type: FlowType = .Flow
    @Published var flowMode: FlowMode = .Simple
}
