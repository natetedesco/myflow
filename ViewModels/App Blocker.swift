//
//  App Blocker.swift
//  MyFlow
//  Created by Nate Tedesco on 8/31/23.
//

import Foundation
import ManagedSettings

extension FlowModel {
    
    // Save
    func saveActivitySelection() {
        if let encoded = try? JSONEncoder().encode(activitySelection) {
            UserDefaults.standard.set(encoded, forKey: "activitySelection")
        }
    }
    
    func startRestriction() {
        let applications = activitySelection.applicationTokens
        let categories = activitySelection.categoryTokens
        let webCategories = activitySelection.webDomainTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        store.shield.webDomains = webCategories
    }
    
    func stopRestrictions() {
        store.shield.applications = nil
    }
    
}
