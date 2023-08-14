//
//  Settings.swift
//  MyFlow
//  Created by Nate Tedesco on 5/28/23.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
    @AppStorage("NotificationsOn") var notificationsOn: Bool = true
    @AppStorage("BlockDistractions") var blockDistractions: Bool = false
}
