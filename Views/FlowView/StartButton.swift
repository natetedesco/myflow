//
//  StartButton.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct StartButton: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @AppStorage("Onboarding") var onboarding: Bool = true
    @ObservedObject var model: FlowModel
    
    var body: some View {
        
        // Start Button
        if selectedTab == Tab.home {
            Button {
                model.Start()
                UNUserNotificationCenter.current()
                    .requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }
            } label: {
                    HStack {
                        // Button icon
                        Image(systemName: start ? "play.fill" : "pause.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.ultraThinMaterial)
                            .blendMode(.destinationOut)

                        if next {
                            Text(flow ? "Focus" : "Break")
                                .font(.title3)
                                .foregroundStyle(.ultraThickMaterial)
                                .padding(.leading, 8)
                                .blendMode(.destinationOut)
                        }
                    }
                    .padding(.vertical, next ? 16 : 14)
                    .padding(.horizontal, next ? 24 : 16)
                    .background(Color.myBlue.opacity(0.95))
                    .cornerRadius(next ? 40 : 50)
                    .animation(nil, value: start)
                .animation(.default, value: flow)
                .compositingGroup()
                }
        }
        
        // Flow Circle Button
        if selectedTab == Tab.data || selectedTab == Tab.settings {
            Button {
                selectedTab = Tab.home
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .myBlue()
                        .frame(width: 90, height: 50)
                    Circle()
                        .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 1, lineCap: .round))
                        .myBlue()
                        .frame(width: 90, height: 50)
                        .blur(radius: 5)
                }
            }
        }
    }
    
    var next: Bool {
        if model.mode == .flowStart || model.mode == .breakStart {
            return true
        }
        return false
    }
    
    var start: Bool {
        if model.mode == .Initial || model.mode == .flowStart || model.mode == .breakStart || model.mode == .flowPaused || model.mode == .breakPaused {
            return true
        }
        return false
    }
    
    var flow: Bool {
        if model.mode == .flowStart {
            return true
        }
        return false
    }
}
