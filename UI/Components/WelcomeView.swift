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
                                .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 32)
                        
                        HStack {
                            Image(systemName: "circle")
                                .foregroundColor(.myBlue)
                                .font(.largeTitle)
                                .padding(4)
                                .background(Circle()
                                    .fill(.ultraThinMaterial.opacity(0.55)))
//                                .padding(4)

                            VStack {
                                Text("Create Flows")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("With Interval or time blocking technique")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.footnote)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Image(systemName: "chart.bar")
                                .foregroundColor(.myBlue)
                                .CircularGlassButton()
                                .padding(.leading, -4) // no idea
                            VStack {
                                Text("Visualize progress")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Set a goal and track your progress")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 32)


                        HStack {
                            Image(systemName: "bell")
                                .foregroundColor(.myBlue)
                                .CircularGlassButton()
                            VStack {
                                Text("Allow Notifications")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                Text("Required for app functionality")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.footnote)
                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
                                .foregroundColor(.myBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .background(.ultraThinMaterial.opacity(0.55))
                                .cornerRadius(30)
                        })
                    }
            }
//            .frame(height: 400)
            .customGlass()
        }
        .background(AnimatedBlur(opacity: 0.1))
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
            .preferredColorScheme(.dark)
    }
}

struct DescriptionView: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2).bold()
                .foregroundColor(.white)
            
            Text(text)
                .font(.footnote)
                .foregroundColor(.white)
        }
    }
}

//HStack {
//    Circle()
//        .stroke(lineWidth: 3)
//        .frame(width: 30)
//        .foregroundColor(.myBlue)
//        .padding(.trailing)
//    DescriptionView(
//        title: "Flow",
//        text: "Time for productivity and focus")
//}
//
//HStack {
//    Circle()
//        .stroke(lineWidth: 3)
//        .frame(width: 30)
//        .foregroundColor(.gray)
//        .padding(.trailing)
//    DescriptionView(
//        title: "Break",
//        text: "Time to rest your body and mind")
//}
//
//
//HStack {
//    Image(systemName: "play.fill")
//        .foregroundColor(.myBlue)
//        .font(.system(size: 30))
//        .padding(.trailing)
//    DescriptionView(
//        title: "Start",
//        text: "Cycle between your flows and breaks")
//}
//
//Button(action: {
//    welcomeScreenShown = true },
//       label: {
//    Text("Continue")
//        .foregroundColor(.myBlue)
//        .frame(maxWidth: .infinity)
//        .padding(.vertical)
//        .background(.ultraThinMaterial.opacity(0.55))
//        .cornerRadius(30)
//})
//.padding(.top)
