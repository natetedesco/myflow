//
//  DataView.swift
//  MyFlow
//  Created by Nate Tedesco on 10/20/21.
//

import SwiftUI

struct StatsView: View {
    @StateObject var data = FlowData()
    @StateObject var settings = Settings()
    @State private var showingSheet = false
    
    var hours = [Int](0...8)

    var body: some View {
        ZStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 12) {
                        
                    CustomHeadline(text: "Overview")
                    ZStack {
                        OverViewCard(data: data)
                            .blur(radius: settings.proAccess ? 0 : 5)
                        if !settings.proAccess { lock }
                    }
                    
                    CustomHeadline(text: "This Week")
                    ZStack {
                        WeekCard(data: data)
                            .blur(radius: settings.proAccess ? 0 : 5)
                        if !settings.proAccess { lock }
                    }
                    
                    CustomHeadline(text: "This Month")
                    ZStack {
                        MonthCard(data: data)
                            .blur(radius: settings.proAccess ? 0 : 5)
                        if !settings.proAccess { lock }
                    }
                    }
                }
                .navigationView(title: "Statistics", button: goalMenu)
                .fullScreenCover(isPresented: $showingSheet) {
                    PayWall() }
                Toolbar()
            }
        }
    }
    
    var lock: some View {
        Image(systemName: "lock.fill")
            .foregroundColor(.myBlue)
            .font(.system(size: 20))
    }
    
    @ViewBuilder var goalMenu: some View {
        if settings.proAccess {
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
        } else {
            Button {
                showingSheet.toggle()
            } label: {
                Text("Unlock Pro")
                    .smallButtonGlass()
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
            Text(settings.proAccess ? "Goal" : "Unlock")
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

//                .toolbar{ GoalButton }
//            .blur(radius: data.showGoal ? 10 : 0) // Fucks up view
//            GoalView(data: data, show: $data.showGoal)
//    .background(AnimatedBlur(opacity: moreBlur ? 0.5 : 0.0))
//                .animation(.default.speed(1.5), value: moreBlur)
