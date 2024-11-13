//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI
import StoreKit

struct LargePayWall: View {
    @StateObject var settings = Settings()
    @StateObject var purchaseManager = PurchaseManager()
    
    @Environment(\.dismiss) var dismiss
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertDescription = ""
    
    @State var opacity = 1.0
    
    var body: some View {
        ZStack {
            ZStack {
                AnimatedBlur(opacity: 0.8).offset(y: 50)
                AnimatedBlur(opacity: 1.0).offset(y: 50)
                    .blur(radius: 300)
            }
            .opacity(opacity)
            
            Button {
                softHaptic()
                dismiss()
                withAnimation { opacity = 0.0 }
            } label: {
                Image(systemName: "xmark")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(6)
                    .background(Circle().foregroundStyle(.bar))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.trailing, 32)
            .padding(.top)
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                
                VStack {
                    Text("MyFlow")
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .leading()
                    Text("Pro")
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundStyle(LinearGradient(
                            gradient: Gradient(colors: [.teal, .teal.opacity(0.9)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .leading()
                }
                .padding(.leading, 24)
                
                Spacer()
                
                VStack(spacing: 48) {
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.teal)
                            .fontWeight(.bold)
                        
                        Text("Unlimited Flows")
                            .fontWeight(.medium)
                    }
                    .leading()
                    
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.teal)
                            .fontWeight(.bold)
                        
                        Text("Advanced Controls")
                            .fontWeight(.medium)
                    }
                    .leading()
                    
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.teal)
                            .fontWeight(.bold)
                        
                        Text("Visualize Activity")
                            .fontWeight(.medium)
                        
                    }
                    .leading()
                    
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.teal)
                            .fontWeight(.bold)
                        
                        Text("Block Apps & Websites")
                            .fontWeight(.medium)
                        
                    }
                    .leading()
                    
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.teal)
                            .fontWeight(.bold)
                        
                        Text("Live Activity & Dynamic Island")
                            .fontWeight(.medium)
                    }
                    .leading()
                }
                Spacer()
                
                
                // Terms • Privacy • Restore
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
                    }
                    .padding(.leading, -6)
                }
                .font(.caption)
                .foregroundStyle(.tertiary)
                .fontWeight(.medium)
                .padding(.bottom, 12)
                .centered()
                
                // Subscribe Button
                Button {
                    Task {
                        do {
                            try await purchaseManager.loadProducts()
                            try await purchaseManager.purchase(purchaseManager.products[0])
                        } catch {
                            print(error)
                        }
                    }
                    dismiss()
                    softHaptic()
                    withAnimation { opacity = 0.0 }
                } label: {
                    ZStack {
                        Text("Continue")
                            .foregroundStyle(.white)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .maxWidth()
                            .padding(.vertical)
                            .background(Color.teal)
                            .cornerRadius(24)
                    }
                }
                
                // Terms • Privacy • Restore
                Text("7 days free, then $23.99/year($1.99/month).")
                    .font(.footnote)
                    .padding(.top).padding(.bottom, 4)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .centered()
            }
            .padding(.horizontal, 32)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertDescription), dismissButton: .cancel() )
            }
        }
    }
}

// Small view not working
#Preview {
    LargePayWall()
}
