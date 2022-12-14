//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @ObservedObject var model: FlowModel
    @ObservedObject var data = FlowData()
    
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
                        OverviewCard(data: data)
                        
                        // This Week
                        Text("Weekly")
                            .font(.headline)
                            .padding([.top, .horizontal])
                        WeekCard(data: data)
                        
                        // This Month
                        Text("Monthly")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        MonthCard(data: data)
                    }
                    .padding(.top)
                }
                .padding(.bottom, 80)
                Toolbar(model: model)
            }
            .navigationTitle("Statistics")
            .toolbar{
                Button {
                    data.createDayStruct()
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
