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
        label: { FlowButton() }
            }
        
        if selectedTab == Tab.home {
            Button { model.startInput() }
        label: {
            switch model.mode {
            case .Initial:
                Start(image: "play.circle.fill")
            case .flowRunning:
                Start(image: "pause.circle.fill")
            case .flowPaused:
                Start(image: "play.circle.fill")
            case .breakStart:
                StartNext(image: "play.fill",text: "Break ")
            case .breakRunning:
                Start(image: "pause.circle.fill")
            case .breakPaused:
                Start(image: "play.circle.fill")
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
            .font(.system(size: 50))
    }
}

struct StartNext: View {
    var image: String
    var text: String
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.darkBackground)
                .font(.system(size: 25))
                .padding(.trailing, 5)
            Text(text)
                .font(.body)
                .kerning(3.0)
        }
        .padding(13)
        .foregroundColor(.darkBackground)
        .background(Color.myBlue)
        .cornerRadius(40)
    }
}

struct FlowButton: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.myBlue,style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(.myBlue)
                .frame(width: 90, height: 50)
            Circle()
                .stroke(Color.gray.opacity(0.5),style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 90, height: 35)
        }
    }
}
