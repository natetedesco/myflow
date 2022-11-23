//
//  SimpleFlow.swift
//  MyFlow
//  Created by Nate Tedesco on 9/27/22.
//

import SwiftUI

struct SimpleFlow: View {
    @Binding var flow: Flow
    @State var chooseFlow = false
    @State var chooseBreak = false
    @State var chooseRound = false
    var minutes = [Int](0...60)
    var seconds = [Int](0...60)
    var rounds = [Int](0...10)
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Flow Time
            Button {
                chooseFlow.toggle()
            } label: {
                HStack {
                    Text("Flow")
                        .foregroundColor(.white)
                        .font(.body)

                    Text(formatTime(seconds: (flow.flowSecondsSelection) + (flow.flowMinuteSelection * 60)))
                        .foregroundColor(.myBlue)
                        .font(.callout)
                        .fontWeight(.regular)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Flow Picker
            if chooseFlow {
                    HStack(alignment: .center) {
                        PickerView(selection: $flow.flowMinuteSelection, unit: minutes, label: "min")
                            .frame(maxWidth: 50)
                            .padding(64)
                        
                        PickerView(selection: $flow.flowSecondsSelection, unit: seconds, label: "sec")
                            .frame(maxWidth: 50)
                            .padding(64)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 170)
            }
            
            Divider()
            
            // Break Time
            VStack {
                Button {
                    chooseBreak.toggle()
                } label: {
                    HStack {
                        Text("Break")
                            .foregroundColor(.white)
                        Text(formatTime(seconds: (flow.breakSecondsSelection) + (flow.breakMinuteSelection * 60)))
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Break Picker
                if chooseBreak {
                    HStack {
                        PickerView(selection: $flow.breakMinuteSelection, unit: minutes, label: "min")
                            .frame(maxWidth: 50)
                            .padding(64)
                        
                        PickerView(selection: $flow.breakSecondsSelection, unit: seconds, label: "sec")
                            .frame(maxWidth: 50)
                            .padding(64)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 170)
                }
            }
        }
        
        Divider()
        
        // Rounds
        VStack {
            Button {
                chooseRound.toggle()
            } label: {
                HStack {
                    let rounds = "\(flow.roundsSelection)"
                    Text("Rounds")
                        .foregroundColor(.white)
                    Text(rounds)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if chooseRound {
                PickerView(selection: $flow.roundsSelection, unit: rounds, label: "")
                .frame(maxWidth: .infinity, maxHeight: 170, alignment: .center)
            }
        }
    }
}

struct PickerView: View {
    @Binding var selection: Int
    var unit: [Int]
    var label: String
    var body: some View {
        
        Picker(selection: $selection, label: Text("")) {
            ForEach(0..<unit.count, id: \.self) {
                Text("\(unit[$0]) \(label)")
            }
        }
        .pickerStyle(.wheel)
    }
}
