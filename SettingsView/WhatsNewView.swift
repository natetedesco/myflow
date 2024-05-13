//
//  WhatsNewView.swift
//  MyFlow
//
//  Created by Developer on 5/5/24.
//

import SwiftUI

struct WhatsNewView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                ScrollView {
                    NewRelease(
                        date: "JANUARY 2024 • V3.0",
                        feature: "Introducing New Feature",
                        description: "This is a new feature that is now in the app. it wasn't there before but now it is here")
                    .padding(.top, 136)
                    NewRelease(
                        date: "NOVEMBER 2023 • V2.0",
                        feature: "Introducing New Feature",
                        description: "This is a new feature that is now in the app. it wasn't there before but now it is here")
                    NewRelease(
                        date: "JUNE 2022 • V1.0",
                        feature: "MyFlow Launched",
                        description: "This is a new feature that is now in the app. it wasn't there before but now it is here")
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .navigationTitle("What's New")
//            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true)) {
            WhatsNewView()
                .sheetMaterial()
                .presentationDetents([.medium, .large])
        }}

struct NewRelease: View {
    var date: String
    var feature: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
            
            Text(feature)
                .fontWeight(.medium)
            Text(description)
                .font(.callout)
                .multilineTextAlignment(.leading)
            Divider()
                .padding(.bottom, 32)
        }
    }
}
