//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI
import StoreKit

struct PayWall: View {
    @StateObject var settings = Settings()
    @StateObject var purchaseManager = PurchaseManager()
    
    @Binding var detent: PresentationDetent
    @Environment(\.dismiss) var dismiss
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertDescription = ""
    
    @State var showPlans = true
    
    var body: some View {
        ZStack {
            Color.black.opacity(detent == .large ? 0.6 : 0.0).ignoresSafeArea()
            AnimatedBlur(opacity: 0.8).offset(y: 50)
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                if detent == .large {
                    
                    // MyFlow Pro
                    VStack {
                        Text("MyFlow")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .leading()
                        Text("Pro")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .foregroundStyle(LinearGradient(
                                gradient: Gradient(colors: [.teal, .teal.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .leading()
                    }
                    .padding(.leading, 24)
                    
                    Spacer()
                    
                    // Features
                    VStack(alignment: .leading, spacing: 48) {
                        Feature(text: "Unlimited Flows")
                        Feature(text: "Advanced Controls")
                        Feature(text: "Visualize Activity")
                        Feature(text: "Block Apps & Websites")
                        Feature(text: "Live Activity & Dynamic Island")
                    }
                    
                    Spacer()
                    
                } else {
                    
                    // Your Free Week
                    Text("Your Free Week")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 12)
                        .centered()
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 36)
                                .frame(maxHeight: .infinity)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.01)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(24)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Image(systemName: "lock.open.fill")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black.opacity(0.8))
                                    .frame(width: 16)
                                    .padding(12)
                                
                                Spacer()
                                
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(.black.opacity(0.8))
                                    .frame(width: 16)
                                    .padding(12)
                                
                                Spacer()
                                
                                Image(systemName: "bolt.fill")
                                    .foregroundStyle(Color.teal)
                                    .frame(width: 16)
                                    .padding(12)
                            }
                            .padding(.leading, -16)
                        }
                        VStack(alignment: .leading) {
                            Text("Today")
                                .fontWeight(.semibold)
                            Text("Unlock all features. No payment now.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("Day 6")
                                .fontWeight(.semibold)
                            Text("You will not be charged if you cancel.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("Day 7")
                                .fontWeight(.semibold)
                            Text("$23.99/year($1.99/month) plan begins.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom, 24)
                }
                
                // Terms • Privacy • Restore
                if detent == .large {
                    HStack {
                        Button {
                            if let url = URL(string: "https://myflow.notion.site/MyFlow-Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Terms • Privacy")
                        }
                        
                        Button { Task { do { try await AppStore.sync() } catch { print(error) } }
                        } label: {
                            Text("• Restore")
                        }
                        .padding(.leading, -6)
                    }
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .fontWeight(.medium)
                    .padding(.bottom, 12)
                    .centered()
                }
                
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
                } label: {
                    ZStack {
                        Text(detent != .large ? "Start my free week" : "Try Pro Free")
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
                Text(detent == .large ? "7 days free, then $23.99/year($1.99/month)." : "Swipe up for details")
                    .font(.footnote)
                    .padding(.top)
                    .foregroundStyle(detent == .large ? .secondary : .tertiary)
                    .multilineTextAlignment(.center)
                    .centered()
            }
            .padding(.horizontal, 32)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertDescription), dismissButton: .cancel() )
            }
        }
        .animation(.default, value: detent)
    }
}

// Small view not working
#Preview {
    @State var detent = PresentationDetent.large
    
    return ZStack {}
        .sheet(isPresented: .constant(true)) {
            PayWall(detent: $detent)
                .sheetMaterial()
                .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                .interactiveDismissDisabled(detent == .large)
                .presentationDragIndicator(detent != .large ? .visible : .hidden)
        }
}

struct Feature: View {
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark")
                .foregroundColor(.teal)
                .fontWeight(.bold)
            
            Text(text)
                .fontWeight(.medium)
        }
    }
}
