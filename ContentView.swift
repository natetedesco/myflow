//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("welcomeScreenShown") var welcomeScreenShown: Bool = false
    @AppStorage("ShowToolBar") var showToolBar = true
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @StateObject var model = FlowModel()
    @State var showWelcome = true
    
    init() {
        showToolBar = true
        selectedTab = .home
    }
    
    var body: some View {
        ZStack {
            switch selectedTab {
                
            case .home:
                ZStack {
                    FlowView(model: model)
//                        .onTapGesture {
//                            welcomeScreenShown = false
//                        }
                        
                    if !welcomeScreenShown {
                        MaterialBackGround()
                        WelcomeScreen()
                    }
                }
                
            case .settings:
                    SettingsView(model: model)
                
            case .data:
                    StatsView(model: model)
            }
        }
        .onAppear { UNUserNotificationCenter.current()
            .requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }}
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
