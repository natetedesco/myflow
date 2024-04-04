// ThemePicker.swift
// MyFlow
// Created by Nate Tedesco on 8/30/23.
//

import SwiftUI
import FamilyControls
import ManagedSettings

class Settings: ObservableObject {
    var versionNumber = "v3.3"
    var developerSettings = false
    
    // General
    @AppStorage("NotificationsOn") var notificationsOn: Bool = true
    @AppStorage("LiveActivities") var liveActivities: Bool = true
    
    // Flows
    @AppStorage("BlockDistractions") var blockDistractions: Bool = false
    @AppStorage("focusOnStart") var focusOnStart: Bool = true
    
    // About
    @Published var isShowingMailView = false
    
    // Developer
    @AppStorage("UseDummyData") var useDummyData: Bool = false
    @AppStorage("multiplyTotalFlowTime") var multiplyTotalFlowTime: Bool = false
    @AppStorage("shouldResetTips") var shouldResetTips: Bool = false
    @AppStorage("showFocusByDefault") var showFocusByDefault = true
    @AppStorage("showOnboarding") var showOnboarding: Bool = true

    // Activity Selection
    let center = AuthorizationCenter.shared
    let store = ManagedSettingsStore()
    @Published var activityPresented = false
    @Published var activitySelection = FamilyActivitySelection() { didSet { saveActivitySelection()}}
    @AppStorage("ScreenTimeAuthorized") var isAuthorized: Bool = false
    
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
    
    // Authorize Screen Time
    func authorizeScreenTime() {
        Task { do {
            try await center.requestAuthorization(for: .individual)
            isAuthorized = true
        } catch {
            print("error")
        }}
    }
    
    // Start Restrictions
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
    
    // Stop Restrictions
    func stopRestrictions() {
        store.shield.applications = nil
    }
}
