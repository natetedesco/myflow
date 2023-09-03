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
    @AppStorage("ProAccess") var proAccess: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    
    var hours = [Int](0...8)
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        
                        CustomHeadline(text: "Overview")
                        ZStack {
                            OverViewCard(data: data)
                                .blur(radius: proAccess ? 0 : 3)
                            if !proAccess { lock }
                        }
                        
                        CustomHeadline(text: "This Week")
                        ZStack {
                            WeekCard(data: data)
                                .blur(radius: proAccess ? 0 : 3)
                            if !proAccess { lock }
                        }
                        
                        CustomHeadline(text: "This Month")
                        ZStack {
                            MonthCard(data: data)
                                .blur(radius: proAccess ? 0 : 3)
                            if !proAccess { lock }
                        }
                    }
                }
                .background(.regularMaterial)
                .navigationTitle("Statistics")
                .toolbar {
                    GoalButton
                }
                .sheet(isPresented: $showingSheet) {
                    PayWall()
                }
                //                Toolbar()
            }
        }
    }
    
    var lock: some View {
        Image(systemName: "lock.fill")
            .foregroundColor(.myColor)
            .font(.system(size: 20))
    }
    
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
                .smallButtonGlass()
                .foregroundColor(.clear)
        }
        } else {
            Button {
                showingSheet.toggle()
            } label: {
                Text("Try Pro")
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
            Text(proAccess ? "Goal" : "Unlock")
                .foregroundColor(.myColor)
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

//Button {
//    dismiss()
//} label: {
//    RoundedRectangle(cornerRadius: 16)
//        .foregroundStyle(.ultraThickMaterial)
//        .environment(\.colorScheme, .light)
//        .frame(width: 36, height: 5)
//        .padding(.horizontal)
//        .padding(.top, 8)
//        .padding(.bottom, 24)
//}
