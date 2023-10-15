//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI
import StoreKit

struct PayWall: View {
    @StateObject var settings = Settings()
    @Binding var detent: PresentationDetent
    
    
    @State var monthlySelected = true
    @State var oneTimeSelected = false
    @Environment(\.dismiss) var dismiss
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertDescription = ""
    
    @StateObject var purchaseManager = PurchaseManager()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            AnimatedBlur(opacity: 0.8)
                .offset(y: 50)

            VStack {
                
                Spacer()
                
                if detent == .large {
                    VStack() {
                        Text("Enhance your")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .leading()
                        Text("Flow")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .foregroundColor(.myColor)
                            .leading()
                    }
                    .padding(.top, 64)
                    //                .leading()
                    
                    Spacer()
                    
                    
                    VStack(spacing: 32) {
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.myColor)
                                .fontWeight(.semibold)
                            
                            Text("Unlimited Flows")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.myColor)
                                .fontWeight(.semibold)
                            
                            Text("Advanced Controls")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.myColor)
                                .fontWeight(.semibold)
                            
                            Text("Visualize Activity")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.myColor)
                                .fontWeight(.semibold)
                            
                            Text("Block Apps & Websites")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                            
                        }
                        .leading()
                        
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.myColor)
                                .fontWeight(.semibold)
                            
                            Text("Live Activity & Dynamic Island")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            
                        }
                        .leading()
                        
                    }
                    .font(.title3)
                    
                    Spacer()
                    
                    Text("7 days free, then only $9.99/year")
                        .foregroundStyle(.white.secondary)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .padding(.bottom)
                    
                } else {
                    ZStack {
//                        Spacer()
                        Text("Your free week")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
//                        Spacer()
                        
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white.secondary)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .CircularGlassButton(padding: 8)
                                .trailing()
                        }
                    }
                    .padding(.top)
                    
                    
                    Spacer()
                    
                    HStack {
                        ZStack {
                            
                            Rectangle()
                                .frame(width: 32)
                                .frame(maxHeight: .infinity)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.myColor.opacity(1.0), .myColor.opacity(0.0)]),
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
                                    .foregroundStyle(Color.myColor)
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
                            Text("Your $9.99/year subscription starts ($0.83/month)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            
                        }
                    }
                    .padding(.vertical)
                    .padding(.bottom, 8)
                    
                    Spacer()
                    
                }
                
                // Subscribe Button
                // add notify me option if detent is .medium
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
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.medium)
                            .maxWidth()
                            .padding(.vertical)
                            .background(Color.myColor)
                            .cornerRadius(24)
                    }
                }
                
                if detent == .large {
                    // Terms • Privacy • Restore
                    HStack {
                        Button {
                            if let url = URL(string: "https://myflow.notion.site/MyFlow-Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Terms • Privacy")
                                .foregroundStyle(.white.secondary)
                                .font(.caption)
                            
                        }
                        
                        Button {
                            Task {
                                do {
                                    try await AppStore.sync()
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("• Restore")
                                .foregroundStyle(.white.secondary)
                                .font(.caption)
                        }
                        .padding(.leading, -4)
                        
                    }
                    .padding(.top)
                } else {
                        Text("Swipe up for details")
                            .font(.caption)
                            .foregroundStyle(.white.tertiary)
                            .font(.footnote)
                            .padding(.top, 4)
                            .padding(.bottom, -8)
                    
                }
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
                    .foregroundColor(.myColor)
                    .font(.title3)
                    .padding(8)
                    .background(Circle()
                        .fill(.ultraThinMaterial.opacity(0.55)))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.myColor.opacity(selected ? 0.8 : 0.2))
        .cornerRadius(20)
    }
}


