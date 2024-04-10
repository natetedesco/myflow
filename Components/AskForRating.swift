//
//  WhatsNew.swift
//  MyFlow
//  Created by Nate Tedesco on 12/29/23.
//

import SwiftUI

struct AskForRating: View {
    
    @AppStorage("ratedTheApp") var ratedTheApp: Bool = false
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationView {
            VStack {
                
//
//                Text("Your Feedback is appreciated.")
//                    .font(.callout)
                Spacer()

                HStack {
                    ForEach(0..<5) {_ in
                        Image(systemName: "star.fill")
                            .font(.title2)
                            .foregroundStyle(.teal)
                    }
                }
                
                .padding(.bottom, 24)
                
                Spacer()
                
                Button {
                    requestReview()
                    ratedTheApp = true
                    dismiss()
                } label : {
                    Text("Rate the App")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(
                            gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.8)]),
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        ))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 32)
            .navigationTitle("Enjoying MyFlow?").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                        ratedTheApp = true
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(.white.tertiary)
                            .padding(8)
                            .background(Circle().foregroundStyle(.bar))
                    }
                    .padding(.top, 12)
                }
            }
        }
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
