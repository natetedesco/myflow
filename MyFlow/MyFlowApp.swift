//
//  Flow_TimerApp.swift
//  Flow Timer
//  Created by Nate Tedesco on 6/21/21.
//

import SwiftUI

@main
struct MyFlow: App {
    @StateObject private var purchaseManager = PurchaseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
