//
//  StartButton.swift
//  MyFlow
//  Created by Nate Tedesco on 9/22/21.
//

import SwiftUI

struct ButtonView: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        Button {
            model.Start()
        } label: {
            switch model.mode {
                
            case .Initial:
                StartButton(
                    image: "play.circle.fill")
                
            case .flowRunning:
                StartButton(
                    image: "pause.circle.fill")
                
            case .flowPaused:
                StartButton(
                    image: "play.circle.fill")
                
            case .breakStart:
                StartNextButton(
                    image: "play.fill",
                    text: "Break ")
                
            case .breakRunning:
                StartButton(
                    image: "pause.circle.fill")
                
            case .breakPaused:
                StartButton(
                    image: "play.circle.fill")
                
            case .flowStart:
                StartNextButton(
                    image: "play.fill",
                    text: "Flow")
                
            }
        }
    }
}
struct StartButton: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.myBlue)
            .font(.system(size: 50))
    }
}

struct StartNextButton: View {
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
