//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI
import Charts

struct StatsView: View {
    @StateObject var data = FlowData()
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    
                    CustomHeadline(text: "Overview")
                    OverviewCard
                    
                    CustomHeadline(text: "Weekly")
                    WeekCard
                    
                    CustomHeadline(text: "Monthly")
                    MonthCard
                    
                }
                .statisticsNavigationView()
                .toolbar{ GoalButton }
                .animation(.easeInOut.speed(2.5), value: data.showGoal)
            }
            Toolbar()
            if data.showGoal {
                GoalView
            }
        }
    }
    
    // OverView Card
    var OverviewCard: some View {
            HStack(alignment: .center) {
                OverviewLabel(label: "Today", time: data.todayTime)
                OverviewLabel(label: "This Week", time: data.thisWeekTime)
                OverviewLabel(label: "This Month", time: data.thisMonthTime)
            }
        .cardGlass()
    }
    
    // Week Card
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    var WeekCard: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Callout(text: "Daily flow time goal:")
                Callout(text: "\(data.goalSelection)h")
            }
            
            VStack {
                ZStack {
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(data.thisWeekDays) {_ in
                            Rectangle()
                                .frame(width: 25, height: 60)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    .blendMode(.destinationOut)
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(data.thisWeekDays) { day in
                            BarGraph(value: (CGFloat(day.time/data.goalSelection)))
                        }
                    }
                }
                HStack(alignment: .center, spacing: 16) {
                    ForEach(0..<self.data.thisWeekDays.count, id: \.self) { i in
                        FootNote(text: days[i])
                            .foregroundColor(i == data.dayOfTheWeek ? .myBlue : .gray)
                            .frame(width: 25)
                    }
                }
            }
        }
        .cardGlass()
        .compositingGroup()
    }
    
    var ClearRectangle: some View {
        Rectangle()
            .frame(width: 25, height: 60)
            .foregroundColor(.white)
            .cornerRadius(25)
    }
    
    // Month Card
    var MonthCard: some View {
        VStack {
            Chart(data.thisMonthDays) { day in
                LineMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
                AreaMark(
                    x: .value("Day", day.day, unit: .day),
                    y: .value("Views", Double(day.time) / 60)
                )
                .foregroundStyle(curGradient)
            }
            .accentColor(.myBlue)
            .frame(height: 120)
            .padding(.top, 8)
            .padding(.horizontal, 8)
        }
        .cardGlass()
    }
    
    let curGradient = LinearGradient(
        gradient: Gradient (
            colors: [
                .myBlue.opacity(0.5),
                .myBlue.opacity(0.2),
                .myBlue.opacity(0.05),
           ]
       ),
       startPoint: .top,
       endPoint: .bottom
   )
    
    
    // Goal Button
    var GoalButton: some View {
        Button(action: showGoalCard) {
            Text("Goal")
                .smallButtonGlass()
        }
    }
    
    // Goal View
    var hours = [Int](0...12)
    var GoalView: some View {
        ZStack {
            MaterialBackGround()
                .onTapGesture { data.showGoal = false
                }
            VStack {
                Title2(text: "Daily Flow Time Goal")
                ZStack {
                    Picker(selection: $data.goalSelection, label: Text("")) {
                        ForEach(1..<hours.count, id: \.self) {
                            Text("\(hours[$0])")
                        }
                    }
                    .pickerStyle(.wheel)
                    .padding(-8)
                    Text("Hours")
                        .padding(.leading, 80)
                }
            }
            .customGlass()
            .frame(maxWidth: 380)
        }
    }
    
    func showGoalCard() {
        data.showGoal.toggle()
    }
}

struct OverviewLabel: View {
    var label: String
    var time: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            FootNote(text: label)
            SubHeadline(text: "\(formatHoursAndMinutes(time: time))")
                .foregroundColor(.myBlue)
        }
        .frame(maxWidth: .infinity)
    }
}

struct BarGraph: View {
    var value: CGFloat = 0
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(width: 25, height: 60)
                    .foregroundColor(.clear)
                    .background(.ultraThinMaterial.opacity(0.3))
                
                Rectangle()
                    .frame(width: 25, height: min(value, 60))
                    .foregroundColor(.myBlue)
            }
            .cornerRadius(25)
        }
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}