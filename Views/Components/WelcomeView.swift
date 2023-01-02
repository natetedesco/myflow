//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI

struct WelcomeScreen: View {
    @AppStorage("welcomeScreenShown") var welcomeScreenShown: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            Text("Welcome to MyFlow")
                .font(.title).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)
            
                HStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 30)
                        .foregroundColor(.myBlue)
                        .padding(.trailing)
                    DescriptionView(
                        title: "Flow",
                        text: "Time for productivity and focus")
                }

                HStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 30)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                    DescriptionView(
                        title: "Break",
                        text: "Time to rest your body and mind")
                }
                

                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.myBlue)
                        .font(.system(size: 30))
                        .padding(.trailing)
                    DescriptionView(
                        title: "Start",
                        text: "Cycle between your flows and breaks")
                }
                
                Button(action: {
                    welcomeScreenShown = true },
                       label: {
                    Text("Continue")
                        .foregroundColor(.myBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background(.ultraThinMaterial.opacity(0.55))
                        .cornerRadius(30)
                })
                .padding(.top)

        }
        .customGlass()
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
