//
//  Flow_TimerApp.swift
//  Flow Timer
//  Created by Nate Tedesco on 6/21/21.
//

import SwiftUI
import RevenueCat

@main
struct MyFlow: App {
//    @State var isSubscribed = false

    init() {
        Purchases.configure(withAPIKey: "appl_YweIOyerqgWniIGFTbzgoWTVpJe")
        Purchases.logLevel = .verbose
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onAppear {
//                    Purchases.shared.getCustomerInfo { CustomerInfo, error in
//                        if let info = CustomerInfo {
//                            if info.entitlements["pro"]?.isActive == true {
//                                print("Subscribed")
//                                isSubscribed = true
//                            }
//                        }
//                    }
//                }
        }
    }
}
