//
//  WhatsNewView.swift
//  MyFlow
//  Created by Developer on 5/5/24.
//

import SwiftUI

struct WhatsNewView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                NewRelease(
                    date: "JANUARY 2024 • V3.0",
                    feature: "Introducing Distraction Blocker",
                    description: "Block distracting applications using Apple Screen Time.")
                .padding(.top, 32)
                
                NewRelease(
                    date: "NOVEMBER 2023 • V2.5",
                    feature: "Introducing Activity",
                    description: "Set a daily goal and track your daily flowtime.")
                
                NewRelease(
                    date: "June 2023 • V2.0",
                    feature: "Introducing Custom Flows",
                    description: "Create your own custom flows using focus blocks.")
                
                NewRelease(
                    date: "JUNE 2022 • V1.0",
                    feature: "MyFlow Launched",
                    description: "")
                
            }
            .padding(.horizontal, 20)
            .navigationTitle("What's New")
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ZStack {}
        .sheet(isPresented: .constant(true)) {
            WhatsNewView()
                .sheetMaterial()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
        }
}

struct NewRelease: View {
    var date: String
    var feature: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
            
            Text(feature)
                .fontWeight(.medium)
            Text(description)
                .font(.callout)
                .multilineTextAlignment(.leading)
            Divider()
                .padding(.bottom, 24)
        }
    }
}
