// ThemePicker.swift
// MyFlow
//
// Created by Nate Tedesco on 8/30/23.
//

import SwiftUI
import FamilyControls
import ManagedSettings

class Settings: ObservableObject {
    
    @AppStorage("NotificationsOn") var notificationsOn: Bool = true
    
    @AppStorage("BlockDistractions") var blockDistractions: Bool = false
    
    @AppStorage("LiveActivities") var liveActivities: Bool = true
    
    @AppStorage("FocusMode") var focusMode: Bool = true
    
    let store = ManagedSettingsStore()
    var activitySelection = FamilyActivitySelection() { didSet { saveActivitySelection()}}
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "activitySelection") {
            if let decoded = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) {
                activitySelection = decoded
            }
        }
    }
    
    // Save
    func saveActivitySelection() {
        if let encoded = try? JSONEncoder().encode(activitySelection) {
            UserDefaults.standard.set(encoded, forKey: "activitySelection")
        }
    }
    
    func startRestriction() {
        
        if blockDistractions {
            let applications = activitySelection.applicationTokens
            let categories = activitySelection.categoryTokens
            let webCategories = activitySelection.webDomainTokens
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
            store.shield.webDomains = webCategories
        }
    }
    
    func stopRestrictions() {
        store.shield.applications = nil
    }
    
}


//static let myBlue = Color(#colorLiteral(red: 0, green: 0.8217858727, blue: 1, alpha: 1))
