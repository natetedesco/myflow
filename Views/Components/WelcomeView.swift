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
            AnimatedBlur(opacity: 0.05)
                .offset(y: 200)
            AnimatedBlur(opacity: 0.075)
            AnimatedBlur(opacity: 0.05)
                .offset(y: -200)
            VStack(alignment: .leading, spacing: 32) {
                Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Image(systemName: "xmark")
                            .myBlue()
                            .CircularGlassButton()
                        
                            Text("PRO")
                            .font(.system(size: 80))
                            .kerning(5.0)
                                .fontWeight(.bold)
                                .centered()
                                .foregroundColor(.myBlue)
                                .padding(.bottom, 48)
                        
                        Text("Try myFlow Pro for free")
                            .centered()
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom, 48)

                        
                        
                        HStack {
                            Image(systemName: "circle")
                                .myBlue()
                                .font(.largeTitle)
                                .padding(4)
                                .background(Circle()
                                    .fill(.ultraThinMaterial.opacity(0.55)))

                            VStack {
                                Text("Custom Flows")
                                    .font(.headline)
                                    .leading()
                                Text("Create your optimal workflow")
                                    .leading()
                            }
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .myBlue()
                                .CircularGlassButton()
                                .padding(.leading, -4) // no idea
                            VStack {
                                Text("Visualize progress")
                                    .font(.headline)
                                    .leading()
                                Text("Set goals and track your progress")
                                    .leading()
                            }
                        }
                        .leading()
                        .padding(.top, 32)

                        HStack {
                            Image(systemName: "switch.2")
                                .myBlue()
                                .CircularGlassButton()
                            VStack {
                                Text("Advanced Controls")
                                    .leading()
                                    .font(.headline)
                                Text("Customize your flow experience")
                                    .leading()
                            }
                        }
                        .leading()
                        .padding(.bottom, 48)
                        .padding(.top, 32)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("$9.99 One-Time")
                                .fontWeight(.semibold)
                            Text("Pay once. Use forever.")
                                .leading()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.myBlue.opacity(0.2))
                        .cornerRadius(20)
                        .padding(.bottom)
                        
                        HStack {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("$0.99 Monthly")
                                    .fontWeight(.semibold)
                                Text("First 7 days free")
                                    .leading()
                                
                            }
                            Image(systemName: "checkmark")
                                .font(.system(size: 15))
                                .myBlue()
                                .font(.title3)
                                .padding(8)
                                .background(Circle()
                                    .fill(.ultraThinMaterial.opacity(0.55)))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.myBlue.opacity(0.8))
                        .cornerRadius(20)
//                        .padding(.bottom, 64)

                        Text("Restore Purchase • Terms & Privacy")
                            .centered()
                            .font(.footnote)
                            .padding(32)

                        
                        Button(action: {
                            showWelcome = false
                            showCreateFlow = true
                            UNUserNotificationCenter.current()
                                .requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }
                        },
                               label: {
                            Text("Start Trial")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .myBlue()
                                .maxWidth()
                                .padding(.vertical)
                                .background(.ultraThinMaterial.opacity(0.55))
                                .cornerRadius(30)
                                .padding(.bottom, 64)
                        })
                    }
            }
            .padding(24)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .preferredColorScheme(.dark)
    }
}
