//
//  GoalView.swift
//  MyFlow
//  Created by Nate Tedesco on 12/16/22.
//

import SwiftUI

struct GoalView: View {
    @AppStorage("GoalTime") var goalSelection: Int = 0
    @Binding var showGoal: Bool
    var hours = [Int](0...12)
    var days = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .onTapGesture { showGoal = false
                }
            VStack {
                    VStack {
                        Text("Daily Flow Time Goal")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                        
                        HStack(spacing: 15.0) {
                            ForEach(0..<self.days.count, id: \.self) { index in
                                DayButton(day: days[index])
                            }
                        }
                        
                        ZStack {
                            Picker(selection: $goalSelection, label: Text("")) {
                                ForEach(0..<hours.count, id: \.self) {
                                    Text("\(hours[$0])")
                                }
                            }
                            .pickerStyle(.wheel)
                            HStack {
                                Text("hours")
                                    .foregroundColor(.white)
                                    .padding(.leading, 100)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .modifier(CustomGlass())
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(showGoal: .constant(false))
    }
}
