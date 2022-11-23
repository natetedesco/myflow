//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBlur()
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        // Overview
                        Text("Overview")
                            .font(.headline)
                            .padding(.leading)
                        OverviewCard()
                        
                        // This Week
                        Text("Weekly")
                            .font(.headline)
                            .padding([.top, .horizontal])
                        WeekCard()
                        
                        // This Month
                        Text("Monthly")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        MonthCard()
                        
                    }
                    .padding(.top)
                }
                .padding(.bottom, 80)
                Toolbar(model: model)
            }
            .navigationTitle("Statistics")
            .toolbar{
                Button {
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.myBlue)
                        .font(.headline)
                }
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(model: FlowModel())
    }
}
