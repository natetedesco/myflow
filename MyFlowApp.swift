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
                if model.settings.showOnboarding {
                    OnboardingView(model: model)
                }
            }
        }
    }
}

