//
//  WhatsNew.swift
//  MyFlow
//  Created by Nate Tedesco on 12/29/23.
//

import SwiftUI

struct AskForRating: View {
    @StateObject var settings = Settings()
    @AppStorage("ratedTheApp") var ratedTheApp: Bool = false
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationView {
            VStack {
                
                Text("Enjoying MyFlow?")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .padding(.top, -8)
                
                Spacer()

                Text("Support the app by leaving a positive review. We greatly appreciate it.")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                
                Spacer()
                
                Button {
                    requestReview()
                    ratedTheApp = true
                    dismiss()
                } label : {
                    HStack {
                        ForEach(0..<5) {_ in
                            Image(systemName: "star.fill")
                                .font(.title3)
                        }
                    }
                    .foregroundStyle(.white.opacity(0.8))
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
                .padding(.bottom, 20)
                
                Button {
                    settings.isShowingMailView.toggle()
                } label: {
                    Text("or send feedback")
                        .font(.footnote)
                }
                .padding(.bottom, 4)
            }
            .padding(.horizontal, 32)
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
        .sheet(isPresented: $settings.isShowingMailView) {
            MailComposeViewControllerWrapper(isShowing: $settings.isShowingMailView)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingsView(model: FlowModel())
        .sheet(isPresented: .constant(true)) {
            AskForRating()
//                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(40)                .presentationDetents([.fraction(4/10)])
        }
}
