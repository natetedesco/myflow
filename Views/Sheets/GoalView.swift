//
//  GoalView.swift
//  MyFlow
//
//  Created by Nate Tedesco on 12/7/23.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var data: FlowData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            NavigationStack {
                VStack {
                    Text("Daily Flow Goal")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 32)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            if data.goalMinutes > 5 {
                                data.goalMinutes -= 5
                                lightHaptic()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                        }
                        
                        Spacer()
                        Text("\(Int(data.goalMinutes))")
                        
                            .font(.system(size: 80))
                            .fontWeight(.medium)
                            .monospacedDigit()
                            .fontDesign(.rounded)
                        Spacer()
                        
                        Button {
                            data.goalMinutes += 5
                            lightHaptic()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Text("MINUTES/DAY")
                        .font(.callout)
                        .fontWeight(.medium)
                    
                    Spacer()
                    Button {
                        dismiss()
                    } label : {
                        Text("Done")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.teal)
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 24)
            }
            .accentColor(.teal)
        }
    }
}

#Preview {
    GoalView(data: FlowData())
}
