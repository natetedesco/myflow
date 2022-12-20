//
//  ContentView.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @StateObject var model = FlowModel()
    
    var body: some View {
        ZStack {
            switch selectedTab {
                
            case .home:
                ZStack {
                    FlowView(model: model)
                        .background(AnimatedBlurOpaque())
                    Toolbar(model: model)
                }
                
            case .settings:
                ZStack {
                    SettingsView(model: model)
                    Toolbar(model: model)
                }
                
            case .data:
                ZStack {
                    StatsView(model: model)
                    Toolbar(model: model)
                }
                
            case .welcome :
                ZStack {
                    AnimatedBlurOpaque()
                    FlowView(model: model)
                        .blur(radius: 50)
                    WelcomeScreen()
                }
            }
        }
        .onAppear { UNUserNotificationCenter.current()
            .requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

enum Tab: String {
    case home
    case settings
    case data
    case welcome
}
