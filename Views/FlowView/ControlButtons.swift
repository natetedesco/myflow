//
//  ResetButton.swift
//  MyFlow
//  Created by Nate Tedesco on 9/3/22.
//

import SwiftUI

struct Controls: View {
    @ObservedObject var model: FlowModel
    var body: some View {
        
        if model.mode == .flowPaused || model.mode == .breakPaused {
            HStack(spacing: 60) {
                
                // Restart
                Button { model.Restart() }
                label: { ChevronButton(image: "chevron.left") }
                
                // Reset
                Button { model.Reset() }
                label: { ResetButton }
                
                // Skip
                Button { model.Skip() }
                label: { ChevronButton(image: "chevron.right") }
            }
        }
        
        // Top Right Reset
        if model.mode == .flowStart || model.mode == .breakStart {
            Button { model.Reset() }
            label: { ResetButton }
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
        }
    }
    
    var ResetButton: some View {
        Image(systemName: "gobackward")
            .foregroundColor(.myBlue)
            .font(Font.system(size: 25))
    }
}


struct ChevronButton: View {
    var image: String
    
    var body: some View {
        Image(systemName: image)
            .foregroundColor(.myBlue)
            .font(Font.system(size: 25))
    }
}

struct ContinueButton: View {
    @ObservedObject var model: FlowModel

    var body: some View {
        
        if model.mode == .breakStart {
            Button {
                model.continueFlow()
            } label: {
                Text("Continue Flow")
                    .font(.title2)
                    .fontWeight(.light)
                    .accentColor(.myBlue)
            }
        }
    }
}
