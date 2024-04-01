//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @State var model: FlowModel
    @StateObject var data = FlowData()
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @State var showGoal = false
    @State var blur = 0.0
    
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
                            data.showGoal.toggle()
                        } label: {
                            Text("Goal")
                                .foregroundColor(.teal)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if !proAccess {
                        Button {
                            model.showPayWall(large: true)
                        } label: {
                            Text("Unlock")                                    
                                .fontWeight(.medium)
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
            .sheet(isPresented: $data.showGoal) {
                GoalView(data: data)
                    .sheetMaterial()
                    .presentationDetents([.fraction(4/10)])
                    .presentationDragIndicator(.hidden)
            }
        }
    }
}

#Preview {
    StatsView(model: FlowModel())
}
