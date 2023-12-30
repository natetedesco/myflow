//
//  WhatsNew.swift
//  MyFlow
//
//  Created by Nate Tedesco on 12/29/23.
//

import SwiftUI

struct WhatsNew: View {
    var body: some View {
        VStack {
            HStack {
                Text("Enjoying the App?")
//                Text("App?")
//                    .foregroundStyle(.teal)
            }
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            
            Text("Your feedback is appreciated and drives the development of MyFlow.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Spacer()
            Button {
            } label : {
                Text("Rate the App")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(12)
                    .padding(.vertical)
            }
            Button {
                
            } label: {
                Text("Dismiss")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top)
    }
}

#Preview {
    SettingsView(model: FlowModel())
        .sheet(isPresented: .constant(true)) {
            WhatsNew()
                .sheetMaterial()
                .presentationDetents([.fraction(3/10)])
                .darken(amount: 0.3)
        }
}
