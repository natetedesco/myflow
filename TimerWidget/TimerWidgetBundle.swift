//
//  TimerWidgetBundle.swift
//  TimerWidget
//
//  Created by Nate Tedesco on 5/2/23.
//

import WidgetKit
import SwiftUI

@main
struct TimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimerWidget()
        TimerWidgetLiveActivity()
    }
}
