//
//  NavigationLinks.swift
//  MyFlow
//  Created by Nate Tedesco on 10/21/22.
//

import SwiftUI

struct NavigationLabel: View {
    var text: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.white)
            Text(text)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct NavigationList: View {
    var text: String
    var icon: String
    
    var body: some View {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                    .foregroundColor(.white)
                Text(text)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal)
    }
}
