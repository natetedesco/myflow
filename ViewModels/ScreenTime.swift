//
//  ScreenTime.swift
//  MyFlow
//  Created by Nate Tedesco on 5/23/23.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls
import SwiftUI

class MyMonitor: DeviceActivityMonitor, ObservableObject {
    let store = ManagedSettingsStore()
    
    func startRestriction() {
        let model = FlowModel()
        
        let applications = model.activitySelection.applicationTokens
        let categories = model.activitySelection.categoryTokens
        let webCategories = model.activitySelection.webDomainTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        store.shield.webDomains = webCategories
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        store.shield.applications = nil
    }
}
