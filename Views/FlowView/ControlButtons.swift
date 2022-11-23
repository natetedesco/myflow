//
//  ResetButton.swift
//  MyFlow
//  Created by Nate Tedesco on 9/3/22.
//

import SwiftUI

struct Controls: View {
    @ObservedObject var model: FlowModel
    
    var body: some View {
        ZStack {
            
            if model.mode == .breakStart {
                ContinueButton()
            }
            
            // Middle
            if      model.mode == .flowPaused || model.mode == .breakPaused {
                
                HStack(spacing: 60) {
                    
                    // Restart
                    Button {
                        model.Restart()
                    } label: {
                        ChevronButton(image: "chevron.left")
                    }
                    
                    // Reset
                    Button {
                        model.Reset()
                    } label: {
                        ResetButton()
                    }
                    
                    // Skip
                    Button {
                        model.Skip()
                    } label: {
                        ChevronButton(image: "chevron.right")
                    }
                }
                .padding(.bottom, 480)
            }
        }
        
        // Top Right
        if model.mode == .flowStart || model.mode == .breakStart {
            Button(
                action: model.Reset,
                label: { ResetButton()
                        .padding(.bottom, 700)
                        .padding(.leading, 300)
                })
        }
    }
}

struct ResetButton: View {
    var body: some View {
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
    var body: some View {
        Button {
        } label: {
            Text("Continue Flow")
                .font(.title2)
                .fontWeight(.light)
                .accentColor(.myBlue)
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.bottom, 500)
        }
    }
}
