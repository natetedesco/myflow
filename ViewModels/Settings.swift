//
//  Settings.swift
//  MyFlow
//  Created by Nate Tedesco on 1/3/23.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    @AppStorage("StartFlowAutomatically") var startFlowAutomatically: Bool = false
    @AppStorage("StartBreakAutomatically") var startBreakAutomatically: Bool = false
}
