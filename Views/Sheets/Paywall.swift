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
            
            VStack {
                
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
                    
                    VStack(spacing: 40) {
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.teal)
                                .fontWeight(.bold)
                            
                            Text("Unlimited Flows")
//                                .fontWeight(.medium)
//                                .foregroundStyle(.secondary)
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.teal)
                                .fontWeight(.bold)
                            
                            Text("Advanced Controls")
//                                .fontWeight(.medium)
//                                .foregroundStyle(.secondary)

                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.teal)
                                .fontWeight(.bold)
                            
                            Text("Visualize Activity")
//                                .fontWeight(.medium)
//                                .foregroundStyle(.secondary)

                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.teal)
                                .fontWeight(.bold)
                            
                            Text("Block Apps & Websites")
//                                .fontWeight(.medium)
//                                .foregroundStyle(.secondary)

                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.teal)
                                .fontWeight(.bold)
                            
                            Text("Live Activity & Dynamic Island")
//                                .fontWeight(.medium)
//                                .foregroundStyle(.secondary)

                        }
                        .leading()
                    }
                    
                    Spacer()
                    
                } else {
                    Text("Your Free Week")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                    
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
                            .padding(.vertical, -2)
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text("Today")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("Unlock free access to all pro features")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("Day 6")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("Your trial is about to end, you will not be charged if you cancel")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("Day 7")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("Your annual $19.99 subscription begins")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 8)
                    
                    Spacer()
                    
                }
                
                HStack {
                    Button {
                        if let url = URL(string: "https://myflow.notion.site/MyFlow-Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Terms • Privacy")
                            .font(.caption2)
                    }
                    
                    Button { Task { do { try await AppStore.sync() } catch { print(error) }}
                    } label: {
                        Text("• Restore")
                            .font(.caption2)
                    }
                    .padding(.leading, -6)
                }
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
                
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
//                    .foregroundStyle(.secondary)
                    .padding(.top, 12)
//                    .padding(.bottom, -4)
            }
            .padding(.horizontal, 32)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertDescription), dismissButton: .cancel() )
            }
        }
        .animation(.default, value: detent)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PayWall(detent: .constant(.medium))
    }
}

struct PlanSelectionButton: View {
    var mainText: String
    var subText: String
    var selected: Bool
    
    var body: some View {
        
        HStack {
            HStack() {
                Text(mainText)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(subText)
                    .leading()
                    .font(.footnote)
                    .foregroundStyle(.white.secondary)
            }
            
            if selected {
                Image(systemName: "checkmark")
                    .font(.footnote)
                    .foregroundColor(.teal)
                    .font(.title3)
                    .padding(8)
                    .background(Circle()
                        .fill(.ultraThinMaterial.opacity(0.55)))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.teal.opacity(selected ? 0.8 : 0.2))
        .cornerRadius(20)
    }
}


