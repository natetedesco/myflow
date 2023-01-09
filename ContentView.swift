//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @StateObject var model = FlowModel()

    init() {
        selectedTab = .home
    }
    
    var body: some View {
        ZStack {
            switch selectedTab {
                
            case .home:
                FlowView(model: model)
                
            case .settings:
                SettingsView()
                
            case .data:
                StatsView()
            }
        }
//        .onAppear { UNUserNotificationCenter.current()
//            .requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }
            
//        }
    }
}



enum Tab: String {
    case home
    case settings
    case data
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
