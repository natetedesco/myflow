//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @AppStorage("ShowToolBar") var showToolBar = true
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    @ObservedObject var data = FlowData()
    @State var showGoal: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Goal
                GoalButton
                
                // Overview
                Headline(text: "OverView")
                OverviewCard(data: data)
                
                // This Week
                Headline(text: "Weekly")
                WeekCard(data: data)
                
                // This Month
                Headline(text: "Monthly")
                MonthCard(data: data)
                
            }
            .padding(.bottom, 80)
            .navigationTitle("Statistics")
            .background(AnimatedBlur())
            .toolbar{
                Button { showGoal.toggle() }
                label: { Image(systemName: "ellipsis")
                    .foregroundColor(.myBlue)
                .font(.headline) }
            }
        }
        if showGoal {
            GoalView(showGoal: $showGoal)
        }
    }
    
    var GoalButton: some View {
        Button {
            showGoal.toggle(); showToolBar = false
        } label: {
            Text("Goal")
                .foregroundColor(.myBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial.opacity(0.55))
                .cornerRadius(30)
        }
        .padding([.leading, .top])
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(model: FlowModel())
            .preferredColorScheme(.dark)
    }
}
