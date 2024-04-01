//
//  WhatsNew.swift
//  MyFlow
//  Created by Nate Tedesco on 12/29/23.
//

import SwiftUI

struct AskForRating: View {
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
                Text("Enjoying MyFlow?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("Your Feedback is greatly appreciated.")
            
            Spacer()
            
            Button {
                requestReview()
            } label : {
                Text("Leave a Rating")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.teal)
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }
}

#Preview {
    SettingsView(model: FlowModel())
        .sheet(isPresented: .constant(true)) {
            AskForRating()
                .sheetMaterial()
                .presentationDetents([.fraction(3/10)])
        }
}
