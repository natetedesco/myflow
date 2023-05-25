//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @StateObject var data = FlowData()
    
    var hours = [Int](0...8)

    
    var body: some View {
        ZStack {
            ZStack {
                ScrollView {
                    
                    CustomHeadline(text: "Overview")
                    OverViewCard(data: data)
                    
                    CustomHeadline(text: "This Week")
                    WeekCard(data: data)
                    
                    CustomHeadline(text: "This Month")
                    MonthCard(data: data)
                    
                }
                .navigationView(title: "Statistics", button: goalMenu)
                .toolbar{ GoalButton }
                .background(AnimatedBlur(opacity: moreBlur ? 0.5 : 0.0))
                .animation(.default.speed(1.5), value: moreBlur)
                Toolbar()
            }
            //            .blur(radius: data.showGoal ? 10 : 0) // Fucks up view
//            GoalView(data: data, show: $data.showGoal)
        }
    }
    
    var goalMenu: some View {
        ZStack {
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
            .smallButtonGlass()
            .foregroundColor(.clear)
    }
        }
    }
    
    var moreBlur: Bool {
        if data.showGoal {
            return true
        }
        return false
    }
    
    // Goal Button
    var GoalButton: some View {
        Button(action: showGoalCard) {
            Text("Goal")
                .smallButtonGlass()
        }
    }
    
    func showGoalCard() {
        data.showGoal.toggle()
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
