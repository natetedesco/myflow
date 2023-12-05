//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @StateObject var data = FlowData()
//    @StateObject var settings = Settings()
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @State private var showPaywall = false
    @State var detent = PresentationDetent.large
    @State var blur = 0.0
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Overview
                    Text("Overview")
                        .font(.callout)
                        .fontWeight(.medium)
                        .padding(.top)
                    
                    
                    OverViewCard(data: data)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                        .padding(.trailing, -16)

                    // Weekly
                    Text("Weekly")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                    WeekCard(data: data)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                        .padding(.trailing, -16)
                    
                    // Monthly
                    Text("Monthly")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                    MonthCard(data: data)
                        .padding(.horizontal)

                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("Activity")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    goalMenu
                }
                
                ToolbarItem(placement: .bottomBar) {
                    if !proAccess {
                        unlockButton
                    }
                }
            }
            .onAppear {
                if !proAccess {
                    blur = 3.5
                }
            }
            .blur(radius: proAccess ? 0 : blur)
            .animation(.easeIn(duration: 0.4), value: blur)
            .sheet(isPresented: $showPaywall) {
                PayWall(detent: $detent)
                    .presentationCornerRadius(32)
                    .presentationBackground(.regularMaterial)
                    .presentationDetents([.large, .fraction(6/10)], selection: $detent)
                    .interactiveDismissDisabled(detent == .large)
                    .presentationDragIndicator(detent != .large ? .visible : .hidden)
            }
        }
    }
    
    var hours = [Int](0...8)
    @ViewBuilder var goalMenu: some View {
        if proAccess {
            Menu {
                Text("Hours")
                Picker(selection: $data.goalSelection, label: Text("")) {
                    ForEach(1..<hours.count, id: \.self) {
                        Text("\(hours[$0])")
                    }
                }
            }
        label: {
            Text("Goal")
                .foregroundColor(.teal)
            }
        }
    }
    
    var unlockButton: some View {
        Button {
            showPaywall = true
        } label: {
            Text("Unlock")
                .fontWeight(.medium)
                .foregroundColor(.teal)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}

