//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI
import Charts

struct StatsView: View {
    @AppStorage("ShowToolBar") var showToolBar = true
    @AppStorage("SelectedTab") var selectedTab: Tab = .home
    @AppStorage("GoalTime") var goalSelection: Int = 2
    @ObservedObject var model: FlowModel
    @ObservedObject var data = FlowData()
    @State var showGoal: Bool = false
    
    var body: some View {
            NavigationView {
                ScrollView {
                    
                    // Overview
                    Headline(text: "Overview")
                    OverviewCard
                    
                    // This Week
                    Headline(text: "Weekly")
                    WeekCard
                    
                    // This Month
                    Headline(text: "Monthly")
                    MonthCard
                    
                }
                .statisticsNavigationView()
                .toolbar{ GoalButton }
                .animation(.easeInOut.speed(2.5), value: showGoal)
            }
            if showGoal {
                GoalView
            }
    }
    
    func showGoalCard() {
        showGoal.toggle()
        showToolBar = false
    }
    
    var GoalButton: some View {
        Button(action: showGoalCard) {
            Text("Goal")
                .smallButtonGlass()
        }
    }
    
    var OverviewCard: some View {
        HStack(alignment: .center) {
            OverviewLabel(label: "Today", time: data.todayTime)
            OverviewLabel(label: "This Week", time: data.thisWeekTime)
            OverviewLabel(label: "This Month", time: data.thisMonthTime)
        }
        .cardGlass()
    }
    
    var MonthCard: some View {
        VStack {
            Chart(data.thisMonthDays) { day in
                LineMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
                PointMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
            }
            .accentColor(.myBlue)
            .frame(height: 120)
            .padding(.top, 8)
            .padding(.horizontal, 8)
        }
        .cardGlass()
    }
    
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var WeekCard: some View {
        VStack(alignment: .center) {
            HStack {
                FootNote(text: "Daily Flow Time Goal")
                    .foregroundColor(.gray)
                SubHeadline(text: "\(goalSelection)h")
            }
            
            VStack {
                ZStack { // make spacing adaptive for larger screens
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(0..<self.data.thisWeekDays.count, id: \.self) { index in
                            Rectangle()
                                .frame(width: 25, height: 60)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    .blendMode(.destinationOut)
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(0..<self.data.thisWeekDays.count, id: \.self) { index in
                            BarGraph(
                                text: days[index],
                                color: index == data.dayOfTheWeek ? .myBlue : .gray,
                                value: (CGFloat(data.thisWeekDays[index].time))
                            )
                        }
                    }
                }
                HStack(alignment: .center, spacing: 16) {
                    ForEach(0..<self.data.thisWeekDays.count, id: \.self) { index in
                        FootNote(text: days[index])
                            .foregroundColor(index == data.dayOfTheWeek ? .myBlue : .gray)
                            .frame(width: 25)
                    }
                }
            }
        }
        .cardGlass()
        .compositingGroup()
    }
    
    // Goal View
    var hours = [Int](0...12)
    var GoalView: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture { showGoal = false; showToolBar = true }
                VStack {
                    Title3(text: "Daily Flow Time Goal")
                        .padding()
                    
                    ZStack {
                        Picker(selection: $goalSelection, label: Text("")) {
                            ForEach(0..<hours.count, id: \.self) {
                                Text("\(hours[$0])")
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Text("Hours")
                            .padding(.leading, 80)
                    }
                    .frame(maxWidth: 200)
                }
                .customGlass()
        }
    }
}

struct OverviewLabel: View {
    var label: String
    var time: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            FootNote(text: label)
                .foregroundColor(.gray)
            SubHeadline(text: "\(formatHoursAndMinutes(time: time))")
                .foregroundColor(.myBlue)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BarGraph: View {
    var text: String = "D"
    var color: Color = .gray
    @State var value: CGFloat = 0
    @AppStorage("GoalTime") var goalSelection: Int = 2
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 25, height: 60)
                    .foregroundColor(.clear)
                    .background(.ultraThinMaterial.opacity(0.3))
                
                Rectangle()
                    .frame(width: 25, height: min(CGFloat(self.value)/CGFloat(goalSelection), 60))
                    .foregroundColor(.myBlue)
            }
            .cornerRadius(25)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(model: FlowModel())
            .preferredColorScheme(.dark)
    }
}
