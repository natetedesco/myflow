//
//  SwiftUIView.swift
//  MyFlow
//
//  Created by Developer on 4/14/24.
//

import SwiftUI
import StoreKit

struct SwiftUIView: View {
    @State var model: FlowModel
    @StateObject var settings = Settings()
    @StateObject var purchaseManager = PurchaseManager()
    
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @Binding var opacity: Double
    
    var body: some View {
        ZStack {
            
            Button {
                softHaptic()
                withAnimation { opacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showOnboarding = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    model.showPayWall(large: false)
                }
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding(6)
                    .background(Circle().foregroundStyle(.bar))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.trailing)
            
            VStack {
                
                VStack {
                    
                    Text("PRO")
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.teal, .teal.opacity(0.9)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                }
                .padding(.top, 80)
                
                Spacer()
                
                Text("Welcome Offer")
                    .font(.footnote)
                    .foregroundStyle(.teal)
                    .fontWeight(.medium)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(.bar)
                    .cornerRadius(24)
                
                Text("Your Free Week")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.vertical, 12)
                
                Text("7 days free. Cancel any time. Then $23.99/year ($1.99/month).")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Spacer()
                
                HStack {
                    Button {
                        if let url = URL(string: "https://myflow.notion.site/MyFlow-Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Terms • Privacy")
                    }
                    Button { Task { do { try await AppStore.sync() } catch { print(error) }}
                    } label: {
                        Text("• Restore")
                            .padding(.leading, -4)
                    }
                }
                .font(.footnote)
                .foregroundStyle(.tertiary)
                .fontWeight(.medium)
                .padding(.top)
                
                Button {
                    softHaptic()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation { opacity = 0 }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        showOnboarding = false
                    }
                    Task {
                        do {
                            try await purchaseManager.loadProducts()
                            try await purchaseManager.purchase(purchaseManager.products[0])
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Try Pro Free")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .maxWidth()
                        .padding(.vertical)
                        .background(.teal)
                        .cornerRadius(28)
                        .padding(.top, 12)
                        .padding(.bottom, 52)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    SwiftUIView(model: FlowModel(), opacity: .constant(1.0))
}
