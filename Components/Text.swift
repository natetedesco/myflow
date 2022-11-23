//
//  Component.swift
//  MyFlow
//  Created by Nate Tedesco on 9/6/22.
//

import SwiftUI

struct Title: View {
    var text: String
    var body: some View {
        ZStack {
            Text(text)
                .font(.largeTitle)
                .fontWeight(.light)
                .kerning(5.0)
                .foregroundColor(.myBlue)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}


struct Headline: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.top)
    }
}

