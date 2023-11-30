//
//  Flow_TimerApp.swift
//  Flow Timer
//  Created by Nate Tedesco on 6/21/21.
//

import SwiftUI

@main
struct MyFlow: App {
    @StateObject private var purchaseManager = PurchaseManager()
    @State private var selection = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                    
                ContentView()
                    .tabItem {
                        Image(systemName: "play.circle.fill")
                            .fontWeight(.heavy)
                            .environment(\.symbolVariants, .none)
                        Text("Flows")
                    }
                
                    StatsView()
                        .tabItem {
                            Image(systemName: "bolt.fill")
                            Text("Activity")
                        }
                        
                    
                    SettingsView(model: FlowModel())
                        .tabItem {
                            Image(systemName: "person")
                            Text("Settings")
                            
                        }
                    
                }
            .accentColor(.teal)
            
            .environmentObject(purchaseManager)
            .task {
                await purchaseManager.updatePurchasedProducts()
            }
        }
    }
}
