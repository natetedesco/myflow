//
//  GoalView.swift
//  MyFlow
//  Created by Nate Tedesco on 12/16/22.
//

import SwiftUI

struct GoalView: View {
    
    @Binding var showGoal: Bool
    @AppStorage("GoalTime") var goalSelection: Int = 0
    var hours = [Int](0...60)
    var days = ["M", "T", "W", "T", "F", "S", "S"]

    
    var body: some View {
        VStack {
            Button {
                showGoal.toggle()
            } label: {
                VStack {
                    Text("Daily Flow Time Goal")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                    
                    HStack(spacing: 15.0) {
                        ForEach(0..<self.days.count, id: \.self) { index in
                            DayButton(day: days[index])
                        }
                    }
                    
                    Picker(selection: $goalSelection, label: Text("")) {
                        ForEach(0..<hours.count, id: \.self) {
                            Text("\(hours[$0]) hours")
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .frame(maxWidth: .infinity)
                .modifier(CustomGlass())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(showGoal: .constant(false))
    }
}
