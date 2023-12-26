//
//  Flow_TimerApp.swift
//  Flow Timer
//  Created by Nate Tedesco on 6/21/21.
//

import SwiftUI
import TipKit

@main
struct MyFlow: App {
    @StateObject private var purchaseManager = PurchaseManager()
    @State var model = FlowModel()
    
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @AppStorage("shouldResetTips") var shouldResetTips: Bool = false
    @AppStorage("showIntro") var showIntroPayWall: Bool = false
    @State var detent = PresentationDetent.fraction(6/10)
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemTeal
    }
    
    var body: some Scene {
        WindowGroup {
            
            if showOnboarding {
                OnboardingView()
            } else {
                
                TabView {
                    MainView(model: model)
                        .tabItem {
                            Image(systemName: "play.circle.fill")
                                .fontWeight(.heavy)
                                .environment(\.symbolVariants, .none)
                            Text("Flows")
                        }
                    
                    StatsView(data: model.data)
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
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
                .task {
                    if shouldResetTips {
                        try? Tips.resetDatastore()
                    }
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
                .sheet(isPresented: $showIntroPayWall) {
                    PayWall(detent: $detent)
                        .presentationCornerRadius(32)
                        .presentationBackground(.bar)
                        .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                        .interactiveDismissDisabled(detent == .large)
                        .presentationDragIndicator(detent != .large ? .visible : .hidden)
                        .presentationBackgroundInteraction(.enabled)
                }
            }
        }
    }
}

