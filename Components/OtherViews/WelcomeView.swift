//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("welcomeScreenShown") var welcomeScreenShown: Bool = false
    @AppStorage("SelectedTab") var selectedTab: Tab = .home

    
    var body: some View {
        VStack {
            WelcomeTitle()
            
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.myBlue)
                        .padding(.trailing)
                    DescriptionView(
                        title: "Flow",
                        text: "Set your Flow Time - time for productivity and focus")
                }
                .padding()

                HStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                    DescriptionView(
                        title: "Break",
                        text: "Set your Break Time - time to rest your body and mind")
                }
                .padding()

                HStack {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.myBlue)
                        .padding(.trailing)
                    DescriptionView(
                        title: "Start",
                        text: "Continuously cycle between your flow and break")
                }
                .padding()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
    
            
            Button(action: {
                selectedTab = .home },
                   label: {
                Text("Continue")
                    .foregroundColor(.black)
                    .padding(.vertical)
            })
            .frame(maxWidth: .infinity)
            .background(Color.myBlue)
            .cornerRadius(30)
            .padding(.vertical, 30)
            .padding(.horizontal)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(30)
                .padding(.vertical, 120)
                .padding(.horizontal)
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

struct WelcomeTitle: View {
    var body: some View {
        Text("Welcome to MyFlow")
            .font(.largeTitle).bold()
            .foregroundColor(.white)
            .padding(.vertical, 30)
    }
}
