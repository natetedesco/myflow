//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var data: FlowData
    @State var showGoal = false
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Overview
                    Text("Overview")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.top, 26)
                    
                    OverViewCard(data: data)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                        .padding(.trailing, -16)
                    
                    // Weekly
                    Text("Weekly")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    WeekCard(data: data)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                        .padding(.trailing, -16)
                    
                    // Monthly
                    Text("Monthly")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    
                    MonthCard(data: data)
                        .padding(.horizontal)
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("Activity")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    if proAccess {
                        Button {
                            showGoal.toggle()
                        } label: {
                            Text("Goal")
                                .foregroundColor(.teal)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if !proAccess {
                        Button {
                            showPaywall = true
                        } label: {
                            Text("Unlock")                                    .fontWeight(.medium)
                        }
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
            .sheet(isPresented: $showGoal) {
                GoalView(data: data)
                    .presentationBackground(.regularMaterial)
                    .presentationCornerRadius(32)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
        }
    }
    
    @AppStorage("ProAccess") var proAccess: Bool = false
    @State private var showPaywall = false
    @State var detent = PresentationDetent.large
    @State var blur = 0.0
    
}

#Preview {
    StatsView(data: FlowData())
}
