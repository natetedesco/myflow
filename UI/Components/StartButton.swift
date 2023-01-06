//
//  StartButton.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct StartButton: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    
    var body: some View {
        
        if selectedTab == Tab.data || selectedTab == Tab.settings {
            Button { selectedTab = Tab.home }
        label: {
            FlowButton()
        }
            }
        
        if selectedTab == Tab.home {
            Button { model.startInput() }
        label: {
            switch model.mode {
            case .Initial:
                Start(image: "play.fill")
            case .flowRunning:
                Start(image: "pause.fill")
            case .flowPaused:
                Start(image: "play.fill")
            case .breakStart:
                StartNext(image: "play.fill",text: "Break ")
            case .breakRunning:
                Start(image: "pause.fill")
            case .breakPaused:
                Start(image: "play.fill")
            case .flowStart:
                StartNext(image: "play.fill",text: "Flow")
            }
        }}
    }
}

struct Start: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.myBlue)
            .font(.system(size: 30))
            .padding(16)
            .background(.ultraThinMaterial.opacity(0.55))
            .cornerRadius(50)
    }
}

struct StartNext: View {
    var image: String
    var text: String
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.myBlue)
                .font(.system(size: 30))
                .padding(.trailing, 5)
            Text(text)
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.myBlue)
        }
        .padding(13)
        .background(.ultraThinMaterial.opacity(0.55))
        .cornerRadius(40)
    }
}

struct FlowButton: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .foregroundColor(.myBlue)
                .frame(width: 90, height: 50)
            Circle()
                .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 1, lineCap: .round))
                .foregroundColor(.myBlue)
                .frame(width: 90, height: 50)
                .blur(radius: 5)
        }
    }
}
