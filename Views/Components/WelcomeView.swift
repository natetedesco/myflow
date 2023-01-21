//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("showWelcome") var showWelcome: Bool = true
    @AppStorage("showCreateFlow") var showCreateFlow: Bool = true

    var body: some View {
        ZStack {
            MaterialBackGround()
            VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 0) {
                            Text("Welcome to MyFlow")
                                .font(.title).fontWeight(.bold)
                                .centered()
                            .padding(.bottom, 32)
                        
                        HStack {
                            Image(systemName: "circle")
                                .myBlue()
                                .font(.largeTitle)
                                .padding(4)
                                .background(Circle()
                                    .fill(.ultraThinMaterial.opacity(0.55)))

                            VStack {
                                Text("Create Flows")
                                    .font(.headline)
                                    .leading()
                                Text("Using time blocks or intervals")
                                    .leading()
                                    .font(.footnote)
                            }
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "chart.bar")
                                .myBlue()
                                .CircularGlassButton()
                                .padding(.leading, -4) // no idea
                            VStack {
                                Text("Visualize progress")
                                    .font(.headline)
                                    .leading()
                                Text("Set a goal and track your progress")
                                    .font(.footnote)
                                    .leading()
                            }
                        }
                        .leading()
                        .padding(.top, 32)

                        HStack {
                            Image(systemName: "bell")
                                .myBlue()
                                .CircularGlassButton()
                            VStack {
                                Text("Allow Notifications")
                                    .leading()
                                    .font(.headline)
                                Text("Required for app functionality")
                                    .leading()
                                    .font(.footnote)
                            }
                        }
                        .leading()
                        .padding(.bottom, 32)
                        .padding(.top, 32)


                        Button(action: {
                            showWelcome = false
                            showCreateFlow = true
                            UNUserNotificationCenter.current()
                                .requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }
                        },
                               label: {
                            Text("Continue")
                                .myBlue()
                                .maxWidth()
                                .padding(.vertical)
                                .background(.ultraThinMaterial.opacity(0.55))
                                .cornerRadius(30)
                        })
                    }
            }
            .customGlass()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .preferredColorScheme(.dark)
    }
}
