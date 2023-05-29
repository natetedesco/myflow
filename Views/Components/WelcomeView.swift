//
//  SwiftUIView.swift
//  MyFlow
//  Created by Nate Tedesco on 7/7/21.
//

import SwiftUI
import RevenueCat

struct PayWall: View {
    @State var monthlySelected = true
    @State var oneTimeSelected = false
    @Environment(\.dismiss) var dismiss
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertDescription = ""
    
    var body: some View {
        ZStack {
            AnimatedBlur(opacity: 0.05).offset(y: 200)
//            AnimatedBlur(opacity: 0.075)
            AnimatedBlur(opacity: 0.05).offset(y: -200)
            VStack(alignment: .leading, spacing: 32) {
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .myBlue()
                            .CircularGlassButton()
                    }
                        
                        Text("PRO")
                            .font(.system(size: 80))
                            .kerning(5.0)
                            .fontWeight(.bold)
                            .centered()
                            .foregroundColor(.myBlue)
                            .padding(.bottom, 48)
                    
//                    Text("Try free")
//                        .centered()
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .padding()

                    
                    HStack {
                        Image(systemName: "circle")
                            .myBlue()
                            .font(.largeTitle)
                            .padding(4)
                            .background(Circle()
                                .fill(.ultraThinMaterial.opacity(0.55)))
                        
                        VStack {
                            Text("Custom Flows")
                                .font(.subheadline)
                                .leading()
                            Text("Create your optimal workflow")
                                .font(.footnote)
                                .leading()
                        }
                    }
                    .leading()
                    
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .myBlue()
                            .CircularGlassButton()
                            .padding(.leading, -4) // no idea
                        VStack {
                            Text("Visualize progress")
                                .font(.subheadline)
                                .leading()
                            Text("Set goals and track your progress")
                                .font(.footnote)
                                .leading()
                        }
                    }
                    .leading()
                    .padding(.top, 32)
                    
                    
                    
                    HStack {
                        Image(systemName: "shield.fill")
                            .myBlue()
                            .CircularGlassButton()
                        VStack {
                            Text("Distraction Blocker")
                                .leading()
                                .font(.subheadline)
                            Text("Restrict applications during flow")
                                .font(.footnote)
                                .leading()
                        }
                    }
                    .leading()
                    .padding(.bottom, 48)
                    .padding(.top, 32)
                    
                    // One Time Button
                    Button {
                        oneTimeSelected = true
                        monthlySelected = false
                    } label: {
                        PlanSelectionButton(
                            selected: $oneTimeSelected,
                            mainText: "$9.99 Yearly",
                            subText: "First 14 days free")
                    }
                    
                    // Monthly Button
                    Button {
                        monthlySelected = true
                        oneTimeSelected = false
                    } label: {
                        PlanSelectionButton(
                            selected: $monthlySelected,
                            mainText: "$0.99 Monthly",
                            subText: "First 7 days free")
                    }
                    
                    Text("Restore Purchase")
                        .centered()
                        .foregroundColor(.gray)
                        .font(.caption)
                        .padding(.bottom, 32)
                        .padding(.top, 8)
                    
                    
                    // Subscribe Button
                    Button {
                        subscribe()
                    } label: {
                        Text("Upgrade")
                            .myBlue()
                            .maxWidth()
                            .padding(.vertical)
                            .background(.ultraThinMaterial.opacity(0.55))
                            .cornerRadius(30)
                            .padding(.bottom, 64)
                    }
                }
            }
            .padding(24)
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertDescription), dismissButton: .cancel() )
            }
        }
    }
    
    func subscribe() {
        Purchases.shared.getOfferings { offerings, error in
            
            if let packages = offerings?.current?.availablePackages {
                Purchases.shared.purchase(package: packages.first!) { transaction, PurchaserInfo, error, userCancelled in
                    
                    if error != nil {
                        alertTitle = "Purchase Failed"
                        alertDescription = "Error: \(error!.localizedDescription)"
                        showAlert.toggle()
                    }
                    
                    if PurchaserInfo?.entitlements["pro"]?.isActive == true {
                        print("success")
                        alertTitle = "Purchase Successful"
                        alertDescription = "You are now subscribed"
                        showAlert.toggle() 
                    }
                }
            }
        }
    }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PayWall()
            .preferredColorScheme(.dark)
    }
}

struct PlanSelectionButton: View {
    @Binding var selected: Bool
    var mainText: String
    var subText: String
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(mainText)
                    .font(.headline)
//                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(subText)
                    .leading()
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            
            if selected {
                Image(systemName: "checkmark")
                    .font(.system(size: 15))
                    .myBlue()
                    .font(.title3)
                    .padding(8)
                    .background(Circle()
                        .fill(.ultraThinMaterial.opacity(0.55)))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.myBlue.opacity(selected ? 0.8 : 0.2))
        .cornerRadius(20)
        .padding(.vertical, 8)
        
    }
}
