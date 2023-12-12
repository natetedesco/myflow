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
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            AnimatedBlur(opacity: 0.8).offset(y: 50)
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                if detent == .large {
                    
                    VStack {
                        Text("Enhance your")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .leading()
                        Text("Flow")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .foregroundColor(.teal)
                            .leading()
                    }
                    
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
                    
                } else {
                    Text("Your Free Week")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                        .centered()
                    
                    Spacer()
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 32)
                                .frame(maxHeight: .infinity)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.teal.opacity(1.0), .teal.opacity(0.0)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .cornerRadius(24)
                                .padding(.trailing)
                            
                            VStack(alignment: .leading) {
                                Image(systemName: "lock.open.fill")
                                    .foregroundStyle(.black.opacity(0.8))
                                    .frame(width: 16)
                                    .padding(8)
                                
                                Spacer()
                                
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(.black.secondary)
                                    .frame(width: 16)
                                    .padding(8)
                                
                                Spacer()
                                
                                Image(systemName: "bolt.fill")
                                    .foregroundStyle(Color.teal)
                                    .frame(width: 16)
                                    .padding(8)
                            }
                            .padding(.leading, -16)
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text("Today")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("Unlock free access to all pro features")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("Day 6")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("Your trial is about to end, you will not be charged if you cancel")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("Day 7")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("Your annual $19.99 subscription begins")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 8)
                    
                    Spacer()
                }
                
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
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .fontWeight(.medium)
                .padding(.bottom, 8)
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
                } label: {
                    ZStack {
                        Text("Start my free week")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .fontWeight(.medium)
                            .maxWidth()
                            .padding(.vertical)
                            .background(Color.teal)
                            .cornerRadius(20)
                    }
                }
                
                // Terms • Privacy • Restore
                Text(detent == .large ? "7 days free, then $19.99/year." : "Swipe up for details")
                    .font(.caption)
                    .padding(.top, 12)
                    .foregroundStyle(.secondary)
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
