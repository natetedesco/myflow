//
//  Rounds.swift
//  MyFlow
//  Created by Nate Tedesco on 10/16/21.
//

import SwiftUI

struct Rounds: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        if model.flowMode == .Simple {
            
            // Initial
            if model.mode == .Initial {
                HStack {
                    ForEach(0 ..< model.roundsSet, id: \.self) {_ in
                        RoundCircleFull
                    }
                }
            }
            
            // Running
            HStack {
                if model.mode != .Initial {
                    ForEach(0 ..< model.roundsCompleted, id: \.self) {_ in
                        RoundCircleFull
                    }
                    if model.mode == .flowRunning || model.mode == .flowPaused {
                        RoundCircleHalfFull
                    }
                }
            }
        }
    }
    
    var RoundCircleFull: some View {
        Circle()
            .frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.5))
            .padding(2)
    }
    
    var RoundCircleHalfFull: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .rotationEffect(.degrees(90))
            .frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.5))
            .padding(2)
    }
}



