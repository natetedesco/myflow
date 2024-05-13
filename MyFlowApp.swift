//
//  Flow_TimerApp.swift
//  Flow Timer
//  Created by Nate Tedesco on 6/21/21.
//

import SwiftUI
import TipKit

@main
struct MyFlow: App {
    @State var model = FlowModel()
    @StateObject private var purchaseManager = PurchaseManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // App Termination
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @AppStorage("FirstTimeOpen") var timesOpend = 0
    @AppStorage("ratedTheApp") var ratedTheApp: Bool = false
    @State var showRateTheApp = false
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemTeal
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {  
                TabView {
                    MainView(model: model)
                        .tabItem {
                            Image(systemName: "play.circle.fill")
                                .fontWeight(.heavy)
                                .environment(\.symbolVariants, .none)
                            Text("Flows")
                        }
                    
                    StatsView(model: model)
                        .tabItem {
                            Image(systemName: "bolt.fill")
                            Text("Activity")
                        }
                    
                    SettingsView(model: model)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Settings")
                        }
                }
                .task {
                    if !model.settings.developerSettings {
                        await purchaseManager.updatePurchasedProducts()
                    }
                    if model.settings.shouldResetTips {
                        try? Tips.resetDatastore()
                    }
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
                .sheet(isPresented: $model.showPayWall) {
                        PayWall(detent: $model.detent)
                            .sheetMaterial()
                            .presentationDetents([.large, .fraction(6/10)], selection: $model.detent)
                            .interactiveDismissDisabled(model.detent == .large)
                            .presentationDragIndicator(.hidden)
                            .presentationBackgroundInteraction(.enabled)
                }
                .fullScreenCover(isPresented: $model.showLargePayWall) {
                    LargePayWall()
                }
                .sheet(isPresented: $showRateTheApp) {
                    AskForRating()
                        .sheetMaterial()
                        .presentationDetents([.fraction(4/10)])
                }
                if model.settings.showOnboarding {
                    OnboardingView(model: model)
                }
            }
            .onAppear {
                if !proAccess && timesOpend > 5 && timesOpend % 5 != 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        softHaptic()
                        model.showLargePayWall.toggle()
                        timesOpend += 1
                    }
                }
                else if !ratedTheApp && timesOpend != 0 && timesOpend % 5 == 0 {
                    showRateTheApp.toggle()
                    timesOpend += 1
                } else {
                    timesOpend += 1
                }
            }
        }
    }
}

// Runs on termiation
class AppDelegate: NSObject, UIApplicationDelegate {
    let model = FlowModel()
    func applicationWillTerminate(_ application: UIApplication) {
        model.stopActivity()
        
        model.settings.stopRestrictions()
        model.notifications.removeAllPendingNotificationRequests()
        // add if flow is running - send a notification
    }
}
