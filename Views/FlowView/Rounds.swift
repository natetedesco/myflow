//
//  Rounds.swift
//  MyFlow
//  Created by Nate Tedesco on 10/16/21.
//

import SwiftUI

struct Rounds: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        
        // Initial
        if model.mode == .Initial {
            HStack {
                ForEach(0 ..< model.roundsSet, id: \.self) {_ in
                    RoundCircleFull()
                }
            }
            .padding(.top, 110)
        }
        
        // Running
        HStack {
            if model.mode != .Initial {
                ForEach(0 ..< model.roundsCompleted, id: \.self) {_ in
                    RoundCircleFull()
                }
                
                if model.flowMode == .Simple {
                    if model.mode == .flowRunning || model.mode == .flowPaused {
                        RoundCircleHalfFull()
                    }
                }
            }
        }
        .padding(.top, 110)
    }
}
    
    struct RoundCircle: View {
        var body: some View {
            Circle()
                .stroke(Color.gray.opacity(0.5),
                        style: StrokeStyle(lineWidth: 2,lineCap: .round))
                .frame(width: 8, height: 8)
                .padding(2)
        }
    }
    
    struct RoundCircleFull: View {
        var body: some View {
            Circle()
                .frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.5))
                .padding(2)
        }
    }

struct RoundCircleHalfFull: View {
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .rotationEffect(.degrees(90))
            .frame(width: 10, height: 10).foregroundColor(.gray.opacity(0.5))
            .padding(2)
    }
}
